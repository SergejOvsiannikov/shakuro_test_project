class CreateBooksShops < ActiveRecord::Migration[5.0]
  def change
    create_table :books_shops do |t|
      t.references :book, foreign_key: true
      t.references :shop, foreign_key: true
      t.integer :books_in_stock, default: 0, null: false
      t.integer :sold_books, default: 0, null: false

      t.timestamps
    end
  end
end
