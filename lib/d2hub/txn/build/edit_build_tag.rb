require_relative '../transaction'

module D2HUB
  class EditBuildTag < Transaction
    def run(id: nil,
        git_type: nil,
        git_branch_name: nil,
        dockerfile_location: nil,
        dockerfile_name: nil,
        docker_tag_name: nil,
        dockerbuild_arg: nil,
        use_regex: nil
    )
      build_tag = BuildTag.first(id: id.to_i)
      build_tag[:git_type] = git_type unless git_type.nil?
      build_tag[:git_branch_name] = git_branch_name unless git_branch_name.nil?
      build_tag[:dockerfile_location] = dockerfile_location unless dockerfile_location.nil?
      build_tag[:dockerfile_name] = dockerfile_name unless dockerfile_name.nil?
      build_tag[:docker_tag_name] = docker_tag_name unless docker_tag_name.nil?
      build_tag[:dockerbuild_arg] = dockerbuild_arg unless dockerbuild_arg.nil?
      build_tag[:use_regex] = use_regex unless use_regex.nil?
      build_tag.save
    end
  end
end