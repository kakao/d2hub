require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'
require_relative '../../../lib/d2hub/txn/active_feed'

module D2HUB
  describe GetActiveFeeds do
    subject { GetActiveFeeds }

    let(:user_name) { 'test_user' }

    before do
      CreateUser.run user_name: user_name
      (1..100).each do |num|
        CreateActiveFeed.run user_name: user_name,
                             action: "action_#{num}"
      end
    end

    it 'should get active feeds' do
      active_feeds = GetActiveFeeds.run user_name: user_name, count: 10
      expect(active_feeds.length).to eq 10

      active_feeds.each_with_index do |active_feed, index|
        expect(active_feed[:action]).to eq "action_#{100 - index}"
      end
    end
  end
end