ENV['ADMINS'] = "['fpgeek82', 'francis']"
ENV['DB_URL'] = 'sqlite://spec/test.db'

require 'rspec'
require_relative '../../lib/d2hub/model'

RSpec.configure do |config|
  config.around(:each) do |example|
    D2HUB::DB.transaction(rollback: :always){ example.run }
  end
end