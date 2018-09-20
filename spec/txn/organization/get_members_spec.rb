require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'
require_relative '../../../lib/d2hub/txn/organization'

module D2HUB
  describe GetMembersOfOrganization do
    subject { GetMembersOfOrganization }

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

    it 'should get members of organization' do
      members = GetMembersOfOrganization.run org_name: params[:org_name]
      expect(members.length).to eq 2
      expect(members[0][:name]).to eq params[:user_name]
      expect(members[0][:role]).to eq 'owner'
      expect(members[1][:name]).to eq params[:member_name]
      expect(members[1][:role]).to eq 'member'
    end
  end
end