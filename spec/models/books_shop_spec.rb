require 'rails_helper'

RSpec.describe BooksShop, type: :model do
  it { is_expected.to belong_to(:book) }
  it { is_expected.to belong_to(:shop) }

  describe '.by_book' do
    let!(:book) { create(:book) }
    let!(:random_book) { create(:book) }
    let!(:books_shop) { create(:books_shop, book: book) }
    let!(:random_books_shop) { create(:books_shop, book: random_book) }

    subject { described_class.by_book(book) }

    specify { is_expected.to include(books_shop) }
    specify { is_expected.to_not include(random_books_shop) }
  end
end
