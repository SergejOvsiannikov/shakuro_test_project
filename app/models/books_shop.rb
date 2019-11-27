class BooksShop < ApplicationRecord
  belongs_to :book
  belongs_to :shop

  scope :by_book, ->(book) { where(book: book) }
end
