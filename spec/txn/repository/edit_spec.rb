require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'
require_relative '../../../lib/d2hub/txn/repository'

module D2HUB
  describe EditRepository do
    subject { EditRepository }

    let(:params) do
      {
          user_name: 'test_user',
          repo_name: 'test_repo',
          description: 'my first repository',
          member_name: 'member_user'
      }
    end

    let(:new_access_type) { 'private' }
    let(:new_description) { 'my repository has edited!!!' }

    before do
      CreateUser.run user_name: params[:user_name]
      CreateUser.run user_name: params[:member_name]
      CreateRepository.run org_name: params[:user_name],
                           repo_name: params[:repo_name],
                           description: params[:description]
    end

    it 'should edit repository info' do
      repo1 = GetRepository.run org_name: params[:user_name],
                                repo_name: params[:repo_name]
      expect(repo1).to be_truthy
      expect(repo1.description).to eq params[:description]
      expect(repo1.access_type).to eq 'public'
      EditRepository.run org_name: params[:user_name],
                         repo_name: params[:repo_name],
                         description: new_description,
                         access_type: new_access_type
      repo2 = GetRepository.run org_name: params[:user_name],
                                repo_name: params[:repo_name]
      expect(repo2).to be_truthy
      expect(repo2.description).to eq new_description
      expect(repo2.access_type).to eq new_access_type
    end
  end
end