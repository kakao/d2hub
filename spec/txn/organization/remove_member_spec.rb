require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'
require_relative '../../../lib/d2hub/txn/organization'

module D2HUB
  describe RemoveMemberFromOrganization do
    subject { RemoveMemberFromOrganization }

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
      CreateOrganization.run user_name: params[:user_name],
                             org_name: params[:org_name]
      AddMemberToOrganization.run org_name: params[:org_name],
                                  user_name: params[:member_name]
    end

    it 'should remove member to organization' do
      before_members = GetMembersOfOrganization.run org_name: params[:org_name]
      expect(before_members.length).to eq 2
      RemoveMemberFromOrganization.run org_name: params[:org_name], user_name: params[:member_name]
      after_members = GetMembersOfOrganization.run org_name: params[:org_name]
      expect(after_members.length).to eq 1
    end
  end
end