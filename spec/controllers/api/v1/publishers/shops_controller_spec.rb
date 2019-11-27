require 'rails_helper'

describe Api::V1::Publishers::ShopsController, type: :controller do
  describe 'GET index' do
    subject { get :index, params: { publisher_id: publisher_id } }

    context 'when get shops' do
      let!(:publisher) { create(:publisher) }
      let(:publisher_id) { publisher.id }

      let!(:random_book) { create(:book) }
      let!(:publisher_book_1) { create(:book, publisher: publisher) }
      let!(:publisher_book_2) { create(:book, publisher: publisher) }
      let!(:shop) { create(:shop) }
      let!(:random_shop) { create(:shop, books: [random_book]) }

      before do
        [random_book, publisher_book_1, publisher_book_2].each do |book|
          create(:books_shop, shop: shop, book: book, books_in_stock: 1, sold_books: 1)
        end
      end

      specify { is_expected.to have_http_status(200) }
      specify do
        parsed_response = JSON.parse(subject.body)

        expect(parsed_response.keys).to include('shops')
        expect(parsed_response['shops'].count ).to eq 1

        shop_response = parsed_response['shops'].first

        expect(shop_response.keys).to match_array(['id', 'name', 'books_sold_count', 'books_in_stock'])
        expect(shop_response['id']).to eq shop.id
        expect(shop_response['name']).to eq shop.name
        expect(shop_response['books_sold_count']).to eq 2
        expect(shop_response['books_in_stock'].count).to eq 2
        expect(shop_response['books_in_stock'].first.keys).to match_array(['id', 'title', 'copies_in_stock'])

        book_1_response = parsed_response['shops'].first['books_in_stock'].find { |book| book['id'] == publisher_book_1.id }

        expect(book_1_response['title']).to eq publisher_book_1.name
        expect(book_1_response['copies_in_stock']).to eq 1

        book_2_response = parsed_response['shops'].first['books_in_stock'].find { |book| book['id'] == publisher_book_2.id }

        expect(book_2_response['title']).to eq publisher_book_2.name
        expect(book_2_response['copies_in_stock']).to eq 1
      end

      context 'when more shops' do
        let!(:shop_2) { create :shop }

        before do
          [random_book, publisher_book_1, publisher_book_2].each do |book|
            create(:books_shop, shop: shop_2, book: book, books_in_stock: 10, sold_books: 3)
          end
        end

        specify do
          parsed_response = JSON.parse(subject.body)

          expect(parsed_response['shops'].count ).to eq 2
          expect(parsed_response['shops'].first['id']).to eq shop_2.id
          expect(parsed_response['shops'].last['id']).to eq shop.id
        end
      end
    end

    context 'with no publisher in DB' do
      let(:publisher_id) { 0 }
      specify { is_expected.to have_http_status(404) }
      specify { expect(subject.body).to eq({ result: "error", message: "Couldn't find Publisher with 'id'=#{publisher_id}" }.to_json) }
    end
  end
end
