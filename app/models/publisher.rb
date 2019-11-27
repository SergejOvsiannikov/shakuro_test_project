class Publisher < ApplicationRecord
  has_many :books
  has_many :shops, -> { distinct }, through: :books
end
