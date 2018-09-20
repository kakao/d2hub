require_relative '../transaction'

module D2HUB
  class EditBuildHistory < Transaction
    def run(id: nil,
            git_url: nil,
            git_branch_name: nil,
            status: nil,
            error_reason: nil,
            dockerfile_content: nil,
            docker_image_name: nil,
            logs: nil
          )
      build_history = BuildHistory.first(id: id.to_i)
      build_history[:git_url] = git_url unless git_url.nil?
      build_history[:git_branch_name] = git_branch_name unless git_branch_name.nil?
      build_history[:status] = status unless status.nil?
      build_history[:error_reason] = error_reason unless error_reason.nil?
      build_history[:dockerfile_content] = dockerfile_content unless dockerfile_content.nil?
      build_history[:docker_image_name] = docker_image_name unless docker_image_name.nil?
      build_history[:logs] = logs unless logs.nil?
      build_history.save
    end
  end
end