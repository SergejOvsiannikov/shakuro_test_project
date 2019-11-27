FactoryBot.define do
  factory :books_shop do
    book
    shop

    sold_books { 1 }
    books_in_stock { 1 }
  end
end
