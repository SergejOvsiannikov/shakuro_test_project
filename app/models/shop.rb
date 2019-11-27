class Shop < ApplicationRecord
  has_many :books_shops
  has_many :books, through: :books_shops

  scope :w_books, -> { joins(:books) }
  scope :for_publisher, ->(publisher) { w_books.where(books: { publisher: publisher }) }
end


