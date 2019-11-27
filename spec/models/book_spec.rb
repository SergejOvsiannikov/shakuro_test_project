require 'rails_helper'

describe Book, type: :model do
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
end
