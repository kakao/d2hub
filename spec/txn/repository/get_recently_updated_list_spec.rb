require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'
require_relative '../../../lib/d2hub/txn/repository'

module D2HUB
  describe GetRecentlyUpdatedRepositories do
    subject { GetRecentlyUpdatedRepositories }

    let(:user_name) { 'test_user' }
    let(:repo_names) { (1..10).map {|n| "repo#{n}"} }

    before do
      CreateUser.run user_name: user_name
      repo_names.each do |repo_name|
        # sleep(0.1)
        CreateRepository.run org_name: user_name, repo_name: repo_name
      end
    end

    it 'should add collaborator' do
      repos = GetRecentlyUpdatedRepositories.run user_name: user_name
      expect(repos.length).to eq 4
      expect(repos[0][:name]).to eq 'repo10'
      expect(repos[3][:name]).to eq 'repo7'
    end
  end
end