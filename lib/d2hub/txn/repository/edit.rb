require_relative '../transaction'
require_relative '../repository/get'

module D2HUB
  class EditRepository < Transaction
    def run(org_name: nil,
            repo_name: nil,
            short_description: nil,
            description: nil,
            access_type: nil,
            download_count: nil,
            build_tags: nil,
            active_build: nil,
            watch_center_id: nil)
      repo = GetRepository.run org_name: org_name,
                               repo_name: repo_name
      repo[:short_description] = short_description unless short_description.nil?
      repo[:description] = description unless description.nil?
      repo[:access_type] = access_type unless access_type.nil?
      repo[:download_count] = download_count unless download_count.nil?
      repo[:active_build] = active_build unless active_build.nil?
      repo[:watch_center_id] = watch_center_id unless watch_center_id.nil?

      unless build_tags.nil?
        param_build_tag_ids = build_tags.map do |bt|
          bt['id']
        end.compact
        repo.build_tags.each do |build_tag|
          unless param_build_tag_ids.include? build_tag[:id]
            build_tag.delete
          end
        end

        build_tags.each do |build_tag|
          if build_tag['id'].nil?
            repo.add_build_tag build_tag
          else
            EditBuildTag.run id: build_tag['id'],
                             git_type: build_tag['git_type'],
                             git_branch_name: build_tag['git_branch_name'],
                             dockerfile_location: build_tag['dockerfile_location'],
                             dockerfile_name: build_tag['dockerfile_name'],
                             dockerbuild_arg: build_tag['dockerbuild_arg'],
                             docker_tag_name: build_tag['docker_tag_name'],
                             use_regex: build_tag['use_regex']
          end
        end
      end
      repo.save
    end
  end
end