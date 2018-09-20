require_relative 'spec_helper'

describe 'user controller test' do
  include Rack::Test::Methods

  def app
    D2HUB::Controller
  end

  after(:all) do
    # File.delete './test.db' if File.exist? './test.db'
  end

  it 'get root' do
    get '/'
    expect(last_response.ok?).to be_truthy
  end

  it 'create user' do
    post '/users/test_user'
    expect(last_response.ok?).to be_truthy

    get '/users/test_user'
    expect(last_response.ok?).to be_truthy
  end
end