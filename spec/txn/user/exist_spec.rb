require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'

module D2HUB
  describe ExistUser do
    subject { ExistUser }

    let(:user_name) { 'test_user' }

    it 'should exists user' do
      exist_user = ExistUser.run user_name: user_name
      expect(exist_user).to be_falsey

      new_user = CreateUser.run user_name: user_name
      expect(new_user[:name]).to eq user_name
      expect(new_user.organizations[0][:name]).to eq user_name

      exist_user = ExistUser.run user_name: user_name
      expect(exist_user).to be_truthy
    end
  end
end