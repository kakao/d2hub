require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'
require_relative '../../../lib/d2hub/txn/repository'

module D2HUB
  describe IsCollaboratorOfRepository do
    subject { IsCollaboratorOfRepository }

    let(:params) do
      {
          repo_name: 'test_repo',
          user_name: 'test_user'
      }
    end
    let(:other_user_name) { 'other_user' }

    before do
      CreateUser.run user_name: params[:user_name]
      CreateUser.run user_name: other_user_name
      CreateRepository.run org_name: params[:user_name],
                           repo_name: params[:repo_name]
    end

    it 'should be collaborator of repository' do
      is_check_star = IsCollaboratorOfRepository.run org_name: params[:user_name],
                                                     repo_name: params[:repo_name],
                                                     user_name: other_user_name
      expect(is_check_star).to be_falsey

      add_result = AddCollaboratorToRepository.run org_name: params[:user_name],
                                                   repo_name: params[:repo_name],
                                                   user_name: other_user_name
      expect(add_result).to be_truthy

      is_check_star = IsCollaboratorOfRepository.run org_name: params[:user_name],
                                                     repo_name: params[:repo_name],
                                                     user_name: other_user_name
      expect(is_check_star).to be_truthy
    end
  end
end