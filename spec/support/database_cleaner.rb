DatabaseCleaner.clean_with :truncation
DatabaseCleaner.strategy = :transaction

RSpec.configure do |config|
  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end
end
