class Moment
  include Mongoid::Document
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  belongs_to :user

  embeds_one :note
  validates_associated :note
  accepts_nested_attributes_for :note

  attr_accessible :note

end
