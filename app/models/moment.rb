class Moment
  include Mongoid::Document
  include Mongoid::Document
  include Mongoid::Timestamps
  # include Mongoid::Paranoia

  field :type, :type => Symbol, :null => false
  validates_inclusion_of :type, :in => [:note, :photo], :message => I18n.t('errors.moment.choose_type')

  embeds_one :note, validate: false
  accepts_nested_attributes_for :note, :reject_if => ->(attrs){ attrs[:body].blank?}

  embeds_one :photo, validate: false
  accepts_nested_attributes_for :photo, :reject_if => ->(attrs){ attrs[:body].blank? }

  attr_accessible :note_attributes, :photo_attributes

  after_validation :even_error_messages

  belongs_to :user
  index :user_id

  before_save :clean_embeds_one_obj

  private

  def clean_embeds_one_obj
    [:note, :photo].each do |type|
      self.send(type).destroy unless self.send(type).nil? or self.send(type).filled?
    end
  end

  def even_error_messages
    flag =  self.type
    if flag.nil?
      [:note, :photo].each do |type|
        if flag
          self.send(type).blank!
        else
          flag = type if not self.send(type).nil? and self.send(type).filled?
        end
      end
    end

    if flag
      unless self.errors[:moment].nil?
        self.send(flag).errors.each{ |attr,msg| self.errors.add(attr, msg)}

        #self.errors.delete :moment
      end
    else
      self.errors.add(:moment, I18n.t('errors.moment.must_complete_one'))
    end

    self.errors.delete :type
  end
end
