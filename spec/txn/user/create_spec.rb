require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'

module D2HUB
  describe CreateUser do
    subject { CreateUser }

    let(:user_name) { 'test_user' }

    it 'should create user and default organization' do
      new_user = CreateUser.run user_name: user_name
      expect(new_user[:name]).to eq user_name
      expect(new_user.organizations[0][:name]).to eq user_name
    end
  end
end