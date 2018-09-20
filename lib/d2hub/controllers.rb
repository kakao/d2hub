require_relative 'base'
require_relative 'controllers/user_controller'
require_relative 'controllers/repository_controller'
require_relative 'controllers/organization_controller'
require_relative 'controllers/search_repo_controller'
require_relative 'controllers/index_controller'
require_relative 'controllers/commnet_controller'
require_relative 'controllers/build_controller'
require_relative 'controllers/rest_api/main'
require 'sinatra/base'

module D2HUB
  class Controller < Sinatra::Base
    use UserController
    use RepositoryController
    use OrganizationController
    use SearchRepoController
    use IndexController
    use CommentController
    use BuildController
    use RestAPI
  end
end