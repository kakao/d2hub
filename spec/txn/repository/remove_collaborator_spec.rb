require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'
require_relative '../../../lib/d2hub/txn/organization'
require_relative '../../../lib/d2hub/txn/repository'

module D2HUB
  describe RemoveCollaboratorFromRepository do
    subject { RemoveCollaboratorFromRepository }

    let(:params) do
      {
          org_name: 'test_org',
          repo_name: 'test_repo',
          user_name: 'test_user',
          member_name: 'member_name'
      }
    end

    before do
      CreateUser.run user_name: params[:user_name]
      CreateUser.run user_name: params[:member_name]
      CreateOrganization.run user_name: params[:user_name],
                             org_name: params[:org_name]
      CreateRepository.run org_name: params[:org_name],
                           repo_name: params[:repo_name]
      AddCollaboratorToRepository.run org_name: params[:org_name],
                                      repo_name: params[:repo_name],
                                      user_name: params[:member_name]
    end

    it 'should remove collaborator from repository' do
      before_collabors = GetCollaboratorsFromRepository.run org_name: params[:org_name],
                                                            repo_name: params[:repo_name]
      expect(before_collabors.length).to eq 2
      RemoveCollaboratorFromRepository.run org_name: params[:org_name], repo_name: params[:repo_name], user_name: params[:user_name]
      after_collabors = GetCollaboratorsFromRepository.run org_name: params[:org_name],
                                                           repo_name: params[:repo_name]
      expect(after_collabors.length).to eq 1
    end
  end
end