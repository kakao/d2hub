require 'sinatra/base'
require 'haml'
require_relative '../txn'
require_relative 'register'

module D2HUB
  class CommentController < D2hubBase
    register ControllerRegister

    post '/comments' do
      redirect back if params[:contents] == ''

      CreateComment.run org_name: params[:org_name],
                        repo_name: params[:repo_name],
                        user_name: user_id,
                        contents: params[:contents]
      redirect back
    end

    delete '/comments/:comment_id' do |comment_id|
      DeleteComment.run comment_id: comment_id

      status 200
    end
  end
end