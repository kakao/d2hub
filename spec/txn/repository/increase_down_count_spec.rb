require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'
require_relative '../../../lib/d2hub/txn/repository'

module D2HUB
  describe IncreaseDownCountOfRepository do
    subject { IncreaseDownCountOfRepository }

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

    it 'should increase download count of repository' do
      result = IncreaseDownCountOfRepository.run org_name: params[:org_name],
                                                 repo_name: params[:repo_name]
      expect(result).to be_truthy

      repo = GetRepository.run org_name: params[:org_name],
                               repo_name: params[:repo_name]

      expect(repo).to be_truthy
      expect(repo[:name]).to eq params[:repo_name]
      expect(repo[:download_count]).to eq 1
    end
  end
end