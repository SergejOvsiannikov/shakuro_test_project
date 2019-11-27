class Book < ApplicationRecord
  has_many :books_shops
  has_many :shops, through: :books_shops

  belongs_to :publisher

  scope :by_publisher, ->(publisher) { where(publisher: publisher) }

  def mark_as_sold!(shop, number_of_copies)
    books_shop = books_shops.find_by!(shop: shop)

    if number_of_copies > books_shop.books_in_stock
      raise Exceptions::Book::InStockLimitExeeded
    end

    books_shop.books_in_stock -= number_of_copies
    books_shop.sold_books += number_of_copies
    books_shop.save!
  end
end
