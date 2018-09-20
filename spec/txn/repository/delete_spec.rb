require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'
require_relative '../../../lib/d2hub/txn/repository'
require_relative '../../../lib/d2hub'

module D2HUB
  describe DeleteRepository do
    subject { DeleteRepository }

    let(:params) do
      {
          user_name: 'test_user',
          repo_name: 'test_repo',
          member_name: 'member_user'
      }
    end

    before do
      CreateUser.run user_name: params[:user_name]
      CreateUser.run user_name: params[:member_name]
      CreateRepository.run org_name: params[:user_name],
                           repo_name: params[:repo_name]
    end

    it 'should delete repository' do
      repo1 = GetRepository.run org_name: params[:user_name],
                                repo_name: params[:repo_name]
      expect(repo1).to be_truthy
      DeleteRepository.run org_name: params[:user_name],
                           repo_name: params[:repo_name]
      repo2 = GetRepository.run org_name: params[:user_name],
                                repo_name: params[:repo_name]
      expect(repo2).to be_nil
    end
  end
end