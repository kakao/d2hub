require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'
require_relative '../../../lib/d2hub/txn/active_feed'

module D2HUB
  describe CreateActiveFeed do
    subject { CreateActiveFeed }

    let(:user_name) { 'test_user' }

    before do
      CreateUser.run user_name: user_name
    end

    it 'should creates active feeds' do
      (1..100).each do |num|
        CreateActiveFeed.run user_name: user_name,
                             action: "action_#{num}"
      end
      active_feeds = GetActiveFeeds.run user_name: user_name, count: 10
      expect(active_feeds.length).to eq 10
    end
  end
end