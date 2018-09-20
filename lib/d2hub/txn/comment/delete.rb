require_relative '../transaction'

module D2HUB
  class DeleteComment < Transaction
    def run(comment_id: nil)
      Comment[comment_id].destroy
    end
  end
end