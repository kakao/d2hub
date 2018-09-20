require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'
require_relative '../../../lib/d2hub/txn/repository'

module D2HUB
  describe AddCollaboratorToRepository do
    subject { AddCollaboratorToRepository }

    let(:params) do
      {
          org_name: 'test_user',
          repo_name: 'test_repo',
          description: 'test repository',
      }
    end

    let(:user_name) { 'test_user' }
    let(:collaborator_name) { 'collaborator' }

    before do
      CreateUser.run user_name: user_name
      CreateUser.run user_name: collaborator_name
      CreateRepository.run params
    end

    it 'should add collaborator' do
      AddCollaboratorToRepository.run org_name: params[:org_name],
                                      repo_name: params[:repo_name],
                                      user_name: collaborator_name
    end
  end
end