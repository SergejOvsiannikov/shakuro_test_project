require 'rails_helper'

RSpec.describe Publisher, type: :model do
  it { is_expected.to have_many(:books) }
end
