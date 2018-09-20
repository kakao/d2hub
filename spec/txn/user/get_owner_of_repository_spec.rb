require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'
require_relative '../../../lib/d2hub/txn/repository'

module D2HUB
  describe GetOwnerOfRepository do
    subject { GetOwnerOfRepository }

    let(:user_name) { 'test_user' }
    let(:repo_name) { 'test_repo' }

    before do
      CreateUser.run user_name: user_name
      CreateRepository.run org_name: user_name,
                           repo_name: repo_name
    end

    it 'should get owner of repository' do
      owner = GetOwnerOfRepository.run org_name: user_name,
                                       repo_name: repo_name
      expect(owner).to be_truthy
      expect(owner[:name]).to eq user_name
    end
  end
end