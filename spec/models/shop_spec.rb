require 'rails_helper'

RSpec.describe Shop, type: :model do
  it { is_expected.to have_many(:books) }
  it { is_expected.to have_many(:books_shops) }

  describe '.w_books' do
    let!(:publisher) { create :publisher }
    let!(:publisher_book) { create :book, publisher: publisher }
    let!(:shop) { create :shop, books: [publisher_book] }
    let!(:random_shop) { create :shop }

    subject { described_class.w_books }

    it { is_expected.to include(shop) }
    it { is_expected.to_not include(random_shop) }
  end

  describe '.for_publisher' do
    let!(:publisher) { create :publisher }
    let!(:publisher_book) { create :book, publisher: publisher }
    let!(:random_book) { create :book }
    let!(:shop) { create :shop, books: [publisher_book, random_book] }
    let!(:random_shop) { create :shop, books: [random_book] }

    subject { described_class.for_publisher(publisher) }

    it { is_expected.to include(shop) }
    it { is_expected.to_not include(random_shop) }
  end
end
