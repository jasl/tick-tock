require 'embedded_models/types/content'

class Moment
  include Mongoid::Document
  include Mongoid::Document
  # include Mongoid::Paranoia

  # TYPES = [:note, :photo] #disabled photo temporarily until impl it.
  TYPES = [:note]

  field :type, :type => Symbol, :null => false
  validates_inclusion_of :type, :in => TYPES

  field :theme, :type => Symbol, :null => false, :default => :classic

  field :year, :type => Integer, :null => false
  validates :year, :presence => true, :inclusion => 2000..2100
  index :year
  field :month, :type => Integer, :null => false
  validates :month, :presence => true, :inclusion => 1..12
  index :month
  field :day, :type => Integer, :null => false
  validates :day, :presence => true, :inclusion => 1..31
  index :day
  field :time, :type => Time, :null => false
  index :time
  attr_accessible :year, :month, :day, :time

  TYPES.each do |type|
    require "embedded_models/types/#{type}"
    embeds_one type, validate: true
    accepts_nested_attributes_for type
    attr_accessible "#{type}_attributes".to_sym
  end

  belongs_to :user
  index :user_id

  before_save :clean_embeds_one_obj
  after_validation :even_error_messages
  after_build :complete_type, :complete_datetime

  def types
    TYPES
  end

  def build_all
    TYPES.each {|type| self.send("build_#{type}") }
  end

  def build_time
    now = Time.now
    self.year = now.year
    self.month = now.month
    self.day = now.day
    self.time = now.localtime # maybe gmtime is better?
  end

  def full_time
    Time.mktime self.year, self.month, self.day, self.time.hour, self.time.min, self.time.sec
  end

  private

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

  def complete_datetime
    if self.time.nil?
      self.build_time
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
