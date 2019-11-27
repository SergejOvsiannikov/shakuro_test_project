class Shop < ApplicationRecord
  has_many :books_shops
  has_many :books, through: :books_shops

  # NOTE: Use only with join on books or books_shops tables
  scope :w_sales_count_ordered, -> { select('SUM(books_shops.sold_books) as books_sold_count, shops.*').group("shops.id").order('books_sold_count DESC') }

  def mark_as_sold!(book, number_of_copies)
    books_shop = books_shops.find_by!(book: book)

    if number_of_copies > books_shop.books_in_stock
      raise Exceptions::Book::InStockLimitExeeded
    end

    books_shop.books_in_stock -= number_of_copies
    books_shop.sold_books += number_of_copies
    books_shop.save!
  end
end


