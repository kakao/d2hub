require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'
require_relative '../../../lib/d2hub/txn/organization'

module D2HUB
  describe CreateOrganization do
    subject { CreateOrganization }

    let(:params) do
      {
          user_name: 'test_user',
          org_name: 'test_org'
      }
    end

    before do
      CreateUser.run user_name: params[:user_name]
    end

    it 'should create organization' do
      new_org = CreateOrganization.run params
      expect(new_org[:name]).to eq params[:org_name]
    end
  end
end