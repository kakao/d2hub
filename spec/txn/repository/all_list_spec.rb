require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'
require_relative '../../../lib/d2hub/txn/repository'

module D2HUB
  describe GetAllRepositories do
    subject { GetAllRepositories }

    let(:user_name) { 'test_user' }

    before do
      CreateUser.run user_name: user_name
      (1..10).each do |num|
        CreateRepository.run org_name: user_name,
                             repo_name: "repo_#{num}"
      end
    end

    it 'should get all repositories' do
      repos = GetAllRepositories.run count: nil
      repos.each_with_index do |repo, index|
        expect(repo[:name]).to eq "repo_#{10 - index}"
      end
    end
  end
end