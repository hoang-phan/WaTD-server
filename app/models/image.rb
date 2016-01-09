class Image < ActiveRecord::Base
  belongs_to :person

  scope :classified, -> { where.not(person: nil) }
end
