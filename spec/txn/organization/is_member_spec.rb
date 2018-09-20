require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'
require_relative '../../../lib/d2hub/txn/organization'

module D2HUB
  describe IsMemberOfOrganization do
    subject { IsMemberOfOrganization }

    let(:params) do
      {
          org_name: 'test_org',
          user_name: 'test_user',
          other_user_name: 'other_user'
      }
    end

    before do
      CreateUser.run user_name: params[:user_name]
      CreateUser.run user_name: params[:other_user_name]
      CreateOrganization.run user_name: params[:user_name],
                             org_name: params[:org_name]
    end

    it 'should be member of organization' do
      is_member_1 = IsMemberOfOrganization.run org_name: params[:org_name],
                                               user_name: params[:other_user_name]
      expect(is_member_1).to be_falsey
      add_result = AddMemberToOrganization.run org_name: params[:org_name],
                                               user_name: params[:other_user_name]

      expect(add_result).to be_truthy

      is_member_2 = IsMemberOfOrganization.run org_name: params[:org_name],
                                               user_name: params[:other_user_name]
      expect(is_member_2).to be_truthy
    end
  end
end