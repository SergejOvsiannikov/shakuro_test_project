FactoryBot.define do
  factory :book do
    publisher

    name { Faker::Book.title }
  end
end
