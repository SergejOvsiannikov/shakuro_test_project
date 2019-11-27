FactoryBot.define do
  factory :publisher do
    name { Faker::Book.publisher }
    email { Faker::Internet.email }
  end
end
