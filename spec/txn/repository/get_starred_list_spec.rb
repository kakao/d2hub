require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'
require_relative '../../../lib/d2hub/txn/repository'

module D2HUB
  describe GetStarredRepositories do
    subject { GetStarredRepositories }

    let(:user1) {
      { name: 'test_user1' }
    }
    let(:user2) {
      { name: 'test_user2' }
    }
    let(:repo_name) { 'repo_name' }

    before do
      CreateUser.run user_name: user1[:name]
      CreateUser.run user_name: user2[:name]
      CreateRepository.run org_name: user1[:name],
                           repo_name: repo_name
      CheckStarToRepository.run user_name: user2[:name],
                                org_name: user1[:name],
                                repo_name: repo_name

    end

    it 'should add collaborator' do
      repos = GetStarredRepositories.run user_name: user2[:name]
      expect(repos.length).to eq 1
      expect(repos[0].name).to eq repo_name
    end
  end
end