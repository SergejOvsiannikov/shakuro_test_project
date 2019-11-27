require 'rails_helper'

RSpec.describe Book, type: :model do
  it { is_expected.to have_many(:books_shops) }
  it { is_expected.to have_many(:shops) }
  it { is_expected.to belong_to(:publisher) }

  describe '.by_publisher' do
    let!(:publisher) { create(:publisher) }
    let!(:book) { create(:book, publisher: publisher) }
    let!(:random_book) { create(:book) }

    subject { described_class.by_publisher(publisher) }

    specify { is_expected.to include book }
    specify { is_expected.to_not include random_book }
  end

  describe '#mark_as_sold!' do
    subject { book.mark_as_sold!(shop, number_of_copies) }

    context 'when book sold' do
      let!(:book) { create :book }
      let!(:shop) { create :shop }
      let!(:books_shop) { create(:books_shop, book: book, shop: shop, books_in_stock: 2, sold_books: 0) }
      let!(:number_of_copies) { 1 }

      it { is_expected.to eq true }

      specify do
        subject
        reloaded_books_shop = books_shop.reload
        expect(reloaded_books_shop.books_in_stock).to eq 1
        expect(reloaded_books_shop.sold_books).to eq 1
      end
    end

    context 'when book is not selling in shop' do
      let!(:book) { create :book }
      let!(:shop) { create :shop }
      let!(:number_of_copies) { 1 }

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'when copies left less than in stock' do
      let!(:book) { create :book }
      let!(:shop) { create :shop }
      let!(:books_shop) { create(:books_shop, book: book, shop: shop, books_in_stock: 0) }
      let!(:number_of_copies) { 1 }

      it { expect { subject }.to raise_error(Exceptions::Book::InStockLimitExeeded) }
    end
  end
end
