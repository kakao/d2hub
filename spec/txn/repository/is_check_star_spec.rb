require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'
require_relative '../../../lib/d2hub/txn/repository'

module D2HUB
  describe IsCheckStarOfRepository do
    subject { IsCheckStarOfRepository }

    let(:params) do
      {
          org_name: 'test_user',
          repo_name: 'test_repo',
          user_name: 'test_user'
      }
    end

    before do
      CreateUser.run user_name: params[:user_name]
      CreateRepository.run org_name: params[:org_name],
                           repo_name: params[:repo_name]
    end

    it 'should be check star of repository' do
      is_check_star = IsCheckStarOfRepository.run user_name: params[:user_name],
                                                  org_name: params[:org_name],
                                                  repo_name: params[:repo_name]
      expect(is_check_star).to be_falsey

      check_star_result = CheckStarToRepository.run user_name: params[:user_name],
                                org_name: params[:org_name],
                                repo_name: params[:repo_name]
      expect(check_star_result).to be_truthy

      is_check_star = IsCheckStarOfRepository.run user_name: params[:user_name],
                                                  org_name: params[:org_name],
                                                  repo_name: params[:repo_name]
      expect(is_check_star).to be_truthy
    end
  end
end