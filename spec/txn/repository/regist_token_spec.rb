require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'
require_relative '../../../lib/d2hub/txn/repository'

module D2HUB
  describe RegistPushKeyOfRepository do
    subject { RegistPushKeyOfRepository }

    let(:params) do
      {
          org_name: 'test_user',
          repo_name: 'test_repo',
          push_key_id: 'push_key_id',
          push_key_password: 'push_key_passowrd'
      }
    end

    let(:user_name) { 'test_user' }

    before do
      CreateUser.run user_name: user_name
      CreateRepository.run org_name: params[:org_name],
                           repo_name: params[:repo_name]
    end

    it 'should create new repository token' do
      RegistPushKeyOfRepository.run org_name: params[:org_name],
                                    repo_name: params[:repo_name],
                                    push_key_id: params[:push_key_id],
                                    push_key_password: params[:push_key_password]
      repo = GetRepository.run org_name: params[:org_name],
                               repo_name: params[:repo_name]
      expect(repo[:push_key_id]).to eq params[:push_key_id]
      expect(repo[:push_key_password]).to eq params[:push_key_password]
    end
  end
end