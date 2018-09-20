require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'
require_relative '../../../lib/d2hub/txn/organization'

module D2HUB
  describe ExistOrganization do
    subject { ExistOrganization }

    let(:params) do
      {
          org_name: 'test_org',
          user_name: 'test_user'
      }
    end

    before do
      CreateUser.run user_name: params[:user_name]
    end

    it 'should exists organization' do
      exist_1 = ExistOrganization.run org_name: params[:org_name]
      expect(exist_1).to be_falsey
      CreateOrganization.run user_name: params[:user_name], org_name: params[:org_name]
      exist_2 = ExistOrganization.run org_name: params[:org_name]
      expect(exist_2).to be_truthy
    end
  end
end