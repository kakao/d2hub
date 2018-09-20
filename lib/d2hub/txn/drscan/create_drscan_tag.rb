require_relative '../transaction'

module D2HUB
  class CreateDrscanTag < Transaction
    def run(org_name: nil,
            repo_name: nil,
            tag_name: nil,
            ticket_id: nil)
      repo = GetRepository.run org_name: org_name, repo_name: repo_name
      drscan_tag = GetDrscanTag.run org_name: org_name,
                                    repo_name: repo_name,
                                    tag_name: tag_name
      if drscan_tag.nil?
        repo.add_drscan_tag name: tag_name,
                            ticket_id: ticket_id
      else
        drscan_tag[:ticket_id] = ticket_id
        drscan_tag.save
      end
    end
  end
end