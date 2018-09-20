require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'
require_relative '../../../lib/d2hub/txn/organization'

module D2HUB
  describe GetOrganization do
    subject { GetOrganization }

    let(:params) do
      {
          org_name: 'test_org',
          user_name: 'test_user'
      }
    end

    before do
      CreateUser.run user_name: params[:user_name]
    end

    it 'should get organization' do
      org_1 = GetOrganization.run org_name: params[:org_name]
      expect(org_1).to be_falsey
      CreateOrganization.run user_name: params[:user_name], org_name: params[:org_name]
      org_2 = GetOrganization.run org_name: params[:org_name]
      expect(org_2).to be_truthy
      expect(org_2[:name]).to eq params[:org_name]
    end
  end
end