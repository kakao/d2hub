require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'
require_relative '../../../lib/d2hub/txn/repository'

module D2HUB
  describe UncheckStarToRepository do
    subject { UncheckStarToRepository }

    let(:data1) do
      {
          user_name: 'test_user1',
          repo_name: 'test_repo1'
      }
    end

    let(:data2) do
      {
          user_name: 'test_user2',
          repo_name: 'test_repo2'
      }
    end

    before do
      @user1 = CreateUser.run user_name: data1[:user_name]
      @user2 = CreateUser.run user_name: data2[:user_name]
      @repo1 = CreateRepository.run org_name: data1[:user_name],
                                    repo_name: data1[:repo_name]
      @repo2 = CreateRepository.run org_name: data2[:user_name],
                                    repo_name: data2[:repo_name]
      CheckStarToRepository.run user_name: data1[:user_name],
                                org_name: data2[:user_name],
                                repo_name: data2[:repo_name]
    end

    it 'should check star to repository' do

      before_stars = DB[:stars].filter(user_id: @user1[:id], repository_id: @repo2[:id])
      expect(before_stars.count).to eq 1

      UncheckStarToRepository.run user_name: data1[:user_name],
                                  org_name: data2[:user_name],
                                  repo_name: data2[:repo_name]

      after_stars = DB[:stars].filter(user_id: @user1[:id], repository_id: @repo2[:id])
      expect(after_stars.count).to eq 0
    end
  end
end