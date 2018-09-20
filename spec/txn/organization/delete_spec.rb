require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'
require_relative '../../../lib/d2hub/txn/organization'

module D2HUB
  describe DeleteOrganization do
    subject { DeleteOrganization }

    let(:params) do
      {
          org_name: 'test_org',
          user_name: 'test_user',
          member_name: 'member_name'
      }
    end

    before do
      CreateUser.run user_name: params[:user_name]
      CreateUser.run user_name: params[:member_name]
      CreateOrganization.run user_name: params[:user_name], org_name: params[:org_name]
      AddMemberToOrganization.run org_name: params[:org_name], user_name: params[:member_name]
    end

    it 'should delete organization' do
      org1 = GetOrganization.run org_name: params[:org_name]
      expect(org1).to be_truthy
      DeleteOrganization.run org_name: params[:org_name]
      org2 = GetOrganization.run org_name: params[:org_name]
      expect(org2).to be_nil
    end
  end
end