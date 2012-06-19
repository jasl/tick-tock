class Moment
  include Mongoid::Document
  include Mongoid::Document
  # include Mongoid::Timestamps
  # include Mongoid::Paranoia

  # TYPES = [:note, :photo] #disabled photo temporarily until impl it.
  TYPES = [:note]

  def types
    TYPES
  end

  field :type, :type => Symbol, :null => false
  validates_inclusion_of :type, :in => TYPES

  field :year, :type => Integer
  index :year
  field :month, :type => Integer
  validates_inclusion_of :month, :in => 1..12
  index :month
  field :day, :type => Integer
  validates_inclusion_of :day, :in => 1..31
  index :day
  field :time, :type => Time
  index :time

  TYPES.each do |type|
    require "embedded_models/types/#{type}"
    embeds_one type, validate: true
    accepts_nested_attributes_for type
    attr_accessible "#{type}_attributes".to_sym
  end

  belongs_to :user
  index :user_id

  before_save :clean_embeds_one_obj, :add_datetime
  after_validation :even_error_messages
  after_build :complete_type

  def build_all
    TYPES.each {|type| self.send("build_#{type}") }
  end

  def full_time
    Time.mktime self.year, self.month, self.day, self.time.hour, self.time.min, self.time.sec
  end

  private

  def add_datetime
    if self.time.nil?
      now = Time.now
      self.year = now.year
      self.month = now.month
      self.day = now.day
      self.time = now.localtime # maybe gmtime is better?
    end
  end

  def complete_type
    TYPES.each do |type|
      unless self.send(type).nil?
        if self.type.nil? and self.send(type).filled?
          self.type = type
        else
          self.send("#{type}=", nil)
        end
      end
    end
  end

  def clean_embeds_one_obj
    TYPES.each do |type|
      self.send("#{type}=", nil) unless self.send(type).nil? or self.send(type).filled?
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
