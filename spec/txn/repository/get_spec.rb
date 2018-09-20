require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'
require_relative '../../../lib/d2hub/txn/repository'

module D2HUB
  describe GetRepository do
    subject { GetRepository }

    let(:params) do
      {
          org_name: 'test_user',
          repo_name: 'test_repo',
          user_name: 'test_user'
      }
    end

    before do
      CreateUser.run user_name: params[:user_name]
    end

    it 'should get repository' do
      repo = GetRepository.run org_name: params[:org_name],
                                   repo_name: params[:repo_name]
      expect(repo).to be_falsey

      new_repo = CreateRepository.run org_name: params[:org_name],
                           repo_name: params[:repo_name]
      expect(new_repo).to be_truthy
      expect(new_repo[:name]).to eq params[:repo_name]


      repo = GetRepository.run org_name: params[:org_name],
                               repo_name: params[:repo_name]
      expect(repo).to be_truthy
      expect(repo[:name]).to eq params[:repo_name]
    end
  end
end