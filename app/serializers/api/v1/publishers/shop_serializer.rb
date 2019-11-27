module Api
  module V1
    module Publishers
      class ShopSerializer < ActiveModel::Serializer
        attributes :id, :name, :books_sold_count, :books_in_stock

        def books_sold_count
          self.object.books_sold_count #books_shops.by_book(instance_options[:publisher].books).pluck(:sold_books).sum
        end

        def books_in_stock
          self.object.books.by_publisher(instance_options[:publisher]).map do |book|
            {
              id: book.id,
              title: book.name,
              copies_in_stock: self.object.books_shops.find_by(book: book).books_in_stock
            }
          end
        end
      end
    end
  end
end
