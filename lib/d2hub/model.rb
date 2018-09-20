require_relative 'base'
require 'sequel'
require 'logger'

module D2HUB
  # MIGRATION_DIR = File.join(File.expand_path('../../../', __FILE__), 'db/migration')
  MIGRATION_DIR = 'db/migration'

  # DB = Sequel.connect ENV['DB_URL'], encoding: 'utf8', loggers: [Logger.new($stdout)]
  DB = Sequel.connect ENV['DB_URL'], encoding: 'utf8'
  DB.sql_log_level = :debug

  Sequel.extension :migration
  Sequel::Migrator.run DB, MIGRATION_DIR unless Sequel::Migrator.is_current? DB, MIGRATION_DIR
  # Sequel::Migrator.run DB, MIGRATION_DIR

  class User < Sequel::Model(:users)
    plugin :json_serializer

    many_to_many :repositories, class: 'D2HUB::Repository',
                  left_key: :user_id, right_key: :repository_id,
                  join_table: :collaborators

    many_to_many :starred_repositories, class: 'D2HUB::Repository',
                 left_key: :user_id, right_key: :repository_id,
                 join_table: :stars

    one_to_many :comments

    many_to_many :organizations,
                  left_key: :user_id, right_key: :organization_id,
                  join_table: :members

    one_to_many :active_feeds
  end

  class Repository < Sequel::Model(:repositories)
    plugin :timestamps
    plugin :json_serializer

    many_to_many :users, class: 'D2HUB::User',
                  left_key: :repository_id, right_key: :user_id,
                  join_table: :collaborators

    many_to_many :starred_users, class: 'D2HUB::User',
                 left_key: :repository_id, right_key: :user_id,
                 join_table: :stars

    one_to_many :comments
    one_to_many :build_tags
    one_to_many :build_histories

    many_to_one :organization

    one_to_many :webhooks
    one_to_many :drscan_tags
  end

  class Organization < Sequel::Model(:organizations)
    plugin :timestamps
    plugin :json_serializer

    many_to_many :users,
                 left_key: :organization_id, right_key: :user_id,
                 join_table: :members

    one_to_many :repositories
  end

  class ActiveFeed < Sequel::Model(:active_feeds)
    plugin :timestamps
    plugin :json_serializer

    many_to_one :user
  end

  class Comment < Sequel::Model(:comments)
    plugin :timestamps
    plugin :json_serializer

    many_to_one :user
    many_to_one :repository
  end

  class BuildTag < Sequel::Model(:build_tags)
    plugin :json_serializer

    many_to_one :repository
    one_to_many :marathon_deploy
    one_to_many :kubernetes_deploy
  end

  class BuildHistory < Sequel::Model(:build_histories)
    plugin :timestamps
    plugin :json_serializer

    many_to_one :repository
  end

  class Webhook < Sequel::Model(:webhooks)
    plugin :timestamps
    plugin :json_serializer

    many_to_one :repository
    one_to_many :webhook_payloads
  end

  class WebhookPayload < Sequel::Model(:webhook_payloads)
    plugin :timestamps
    plugin :json_serializer

    many_to_one :webhook
  end

  class MarathonDeploy < Sequel::Model(:marathon_deploys)
    plugin :timestamps
    plugin :json_serializer

    many_to_one :build_tags
  end

  class KubernetesDeploy < Sequel::Model(:kubernetes_deploys)
    plugin :timestamps
    plugin :json_serializer

    many_to_one :build_tags
  end

  class DrscanTag < Sequel::Model(:drscan_tags)
    plugin :timestamps
    plugin :json_serializer

    many_to_one :repository
  end
end