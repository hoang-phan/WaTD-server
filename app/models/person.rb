class Person < ActiveRecord::Base
  validates :name, length: { maximum: MAX_LENGTH_PERSON_NAME }
  has_many :images
end
