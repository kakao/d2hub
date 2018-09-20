require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'

module D2HUB
  describe GetUser do
    subject { GetUser }

    let(:user_name) { 'test_user' }

    it 'should get user' do
      user = GetUser.run user_name: user_name
      expect(user).to be_falsey

      new_user = CreateUser.run user_name: user_name
      expect(new_user[:name]).to eq user_name
      expect(new_user.organizations[0][:name]).to eq user_name

      user = GetUser.run user_name: user_name
      expect(user).to be_truthy
      expect(user[:name]).to eq user_name
    end
  end
end