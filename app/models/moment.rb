class Moment
  include Mongoid::Document
  include Mongoid::Document
  include Mongoid::Timestamps
  # include Mongoid::Paranoia

  TYPES = [:note, :photo]

  field :type, :type => Symbol, :null => false
  validates_inclusion_of :type, :in => TYPES #, :message => I18n.t('errors.moment.choose_type')

  embeds_one :note, validate: true
  accepts_nested_attributes_for :note, :reject_if => ->(attrs){ attrs[:body].blank?}
  embeds_one :photo, validate: true
  accepts_nested_attributes_for :photo, :reject_if => ->(attrs){ attrs[:body].blank? }

  attr_accessible :note_attributes, :photo_attributes

  belongs_to :user
  index :user_id

  before_save :clean_embeds_one_obj
  before_update :clean_not_use_embeds_one_obj
  after_validation :even_error_messages
  after_build :complete_type

  private

  def complete_type
    TYPES.each.inject(true) do |flag, type|
      unless self.send(type).nil?
        if flag
          self.type = type
          flag = false
        else
          self.send("#{type}=", nil)
        end
      end
      flag
    end
  end

  def clean_embeds_one_obj
    TYPES.each do |type|
      self.send("#{type}=", nil) unless self.send(type).nil? or self.send(type).filled?
    end
  end

  def clean_not_use_embeds_one_obj
    TYPES.each do |type|
      self.send("#{type}=", nil) unless type == self.type
    end
  end

  def even_error_messages
    flag = self.type

    if flag.nil?
      self.errors.add(:moment, I18n.t('errors.moment.must_complete_one'))
    else
      self.send(flag).errors.each{ |attr,msg| self.errors.add(attr, msg)}
    end

    TYPES.each do |type|
      self.send "build_#{type}" if type != flag and self.new_record?
      self.errors.delete type unless self.errors.nil?
    end

    self.errors.delete :type
  end
end
