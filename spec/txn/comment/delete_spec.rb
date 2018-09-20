require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'
require_relative '../../../lib/d2hub/txn/repository'
require_relative '../../../lib/d2hub/txn/comment'

module D2HUB
  describe CreateComment do
    subject { CreateComment }

    let(:repo_name) { 'test_repo' }

    before do
      (1..100).each do |num|
        CreateUser.run user_name: "user_#{num}"
      end
      CreateRepository.run org_name: 'user_1',
                           repo_name: repo_name
      (1..100).each do |num|
        CreateComment.run org_name: 'user_1',
                          repo_name: repo_name,
                          user_name: "user_#{num}",
                          contents: "contents_#{num}"
      end
    end

    it 'should delete comment' do
      comments = GetComments.run org_name: 'user_1', repo_name: repo_name
      expect(comments.length).to eq 100

      comments.each do |comment|
        DeleteComment.run comment_id: comment[:id]
      end

      comments = GetComments.run org_name: 'user_1', repo_name: repo_name
      expect(comments.length).to eq 0
    end
  end
end