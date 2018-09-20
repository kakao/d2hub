require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'
require_relative '../../../lib/d2hub/txn/repository'

module D2HUB
  describe CreateRepository do
    subject { CreateRepository }

    let(:params) do
      {
          org_name: 'test_user',
          repo_name: 'test_repo',
          description: 'test repository'
      }
    end

    let(:user_name) { 'test_user' }

    before do
      CreateUser.run user_name: user_name
    end

    it 'should create repository' do
      new_repo = CreateRepository.run params
      expect(new_repo[:name]).to eq params[:repo_name]
      expect(new_repo[:description]).to eq params[:description]
    end
  end
end