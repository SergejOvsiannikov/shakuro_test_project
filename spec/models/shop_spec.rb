require 'rails_helper'

describe Shop, type: :model do
  it { is_expected.to have_many(:books) }
  it { is_expected.to have_many(:books_shops) }

  describe '.w_sales_count_ordered' do
    let!(:publisher) { create(:publisher) }
    let!(:publisher_book) { create(:book, publisher: publisher) }
    let!(:random_book) { create(:book) }
    let!(:shop_1) { create(:shop) }
    let!(:shop_2) { create(:shop) }

    before do
      [publisher_book, random_book].each do |book|
        create(:books_shop, shop: shop_1, book: book, sold_books: 2)
        create(:books_shop, shop: shop_2, book: book, sold_books: 1)
      end
    end

    subject { described_class.joins(:books).w_sales_count_ordered }

    it { is_expected.to contain_exactly(shop_1, shop_2) }
    it { expect(subject.first.books_sold_count).to eq 4 }
  end

  describe '#mark_as_sold!' do
    subject { shop.mark_as_sold!(book, number_of_copies) }

    context 'when book sold' do
      let!(:book) { create(:book) }
      let!(:shop) { create(:shop) }
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
      let!(:book) { create(:book) }
      let!(:shop) { create(:shop) }
      let!(:number_of_copies) { 1 }

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'when copies left less than in stock' do
      let!(:book) { create(:book) }
      let!(:shop) { create(:shop) }
      let!(:books_shop) { create(:books_shop, book: book, shop: shop, books_in_stock: 0) }
      let!(:number_of_copies) { 1 }

      it { expect { subject }.to raise_error(Exceptions::Book::InStockLimitExeeded) }
    end
  end
end
