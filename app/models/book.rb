class Book < ApplicationRecord
  has_many :books_shops
  has_many :shops, through: :books_shops

  belongs_to :publisher

  scope :by_publisher, ->(publisher) { where(publisher: publisher) }
end
