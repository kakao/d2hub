require_relative './spec_helper'
require_relative '../../lib/d2hub/controllers/auth_controller'

module D2HUB
  describe 'Custom' do
    subject { 'Custom' }

    it 'should exist hardy.jung user' do
      exist = AuthController.exist? 'hardy.jung'
      expect(exist).to be_truthy
    end

    it 'should not exist dummy_test_user user' do
      exist = AuthController.exist? 'dummy_test_user'
      expect(exist).to be_falsey
    end

  end
end