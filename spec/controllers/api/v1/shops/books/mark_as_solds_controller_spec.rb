require 'rails_helper'

describe Api::V1::Shops::Books::MarkAsSoldsController, type: :controller do
  describe 'POST create' do
    subject { post :create, params: { book_id: book_id, shop_id: shop_id, number_of_copies: number_of_copies } }

    context 'when book sold' do
      let!(:book) { create(:book) }
      let!(:shop) { create(:shop) }
      let!(:books_shop) { create(:books_shop, shop: shop, book: book, sold_books: 0, books_in_stock: 1) }

      let!(:book_id) { book.id }
      let!(:shop_id) { shop.id }
      let!(:number_of_copies) { 1 }

      specify { is_expected.to have_http_status(201) }
      specify do
        subject
        reloaded_books_shop = books_shop.reload
        expect(reloaded_books_shop.books_in_stock).to eq 0
        expect(reloaded_books_shop.sold_books).to eq 1
      end
    end

    describe 'errors' do
      context 'when no book in DB' do
        let!(:shop) { create(:shop) }
        let!(:book_id) { shop.id }
        let!(:shop_id) { shop.id }
        let!(:number_of_copies) { 1 }

        specify { is_expected.to have_http_status(404) }
        specify { expect(subject.body).to eq({ result: 'error', message: "Couldn't find Book with 'id'=#{book_id}" }.to_json) }
      end

      context 'when no shop in DB' do
        let!(:book) { create(:book) }
        let!(:book_id) { book.id }
        let!(:shop_id) { book.id }
        let!(:number_of_copies) { 1 }

        specify { is_expected.to have_http_status(404) }
        specify { expect(subject.body).to eq({ result: 'error', message: "Couldn't find Shop with 'id'=#{shop_id}" }.to_json) }
      end

      context 'when no number_of_copies param' do
        let!(:book) { create(:book) }
        let!(:shop) { create(:shop) }
        let!(:book_id) { book.id }
        let!(:shop_id) { shop.id }
        let!(:number_of_copies) { nil }

        specify { is_expected.to have_http_status(404) }
        specify { expect(subject.body).to eq({ result: 'error', message: "number_of_copies param is required" }.to_json) }
      end

      context 'when number_of_copies not Integer' do
        let!(:book) { create(:book) }
        let!(:shop) { create(:shop) }
        let!(:book_id) { book.id }
        let!(:shop_id) { shop.id }
        let!(:number_of_copies) { 'abc' }

        specify { is_expected.to have_http_status(403) }
        specify { expect(subject.body).to eq({ result: 'error', message: "invalid value for Integer(): \"abc\"" }.to_json) }
      end

      context 'when no book in the shop' do
        let!(:book) { create(:book) }
        let!(:shop) { create(:shop) }
        let!(:book_id) { book.id }
        let!(:shop_id) { shop.id }
        let!(:number_of_copies) { 1 }

        specify { is_expected.to have_http_status(404) }
        specify { expect(subject.body).to eq({ result: 'error', message: "Book with id=#{book_id} is not selling in shop with id=#{shop_id}" }.to_json) }
      end

      context 'when no copies in stock' do
        let!(:book) { create(:book) }
        let!(:shop) { create(:shop) }
        let!(:books_shop) { create(:books_shop, shop: shop, book: book, books_in_stock: 0) }
        let!(:book_id) { book.id }
        let!(:shop_id) { shop.id }
        let!(:number_of_copies) { 1 }

        specify { is_expected.to have_http_status(403) }
        specify { expect(subject.body).to eq({ result: 'error', message: "You want to sell more book than we have in stock" }.to_json) }
      end
    end
  end
end
