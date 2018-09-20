ENV['ADMINS'] = "['fpgeek82', 'francis']"
ENV['DB_URL'] = 'sqlite://test.db'
ENV['API_DOCKER_REGISTRY_URL'] = 'http://10.42.0.11:7000'

require_relative '../../lib/d2hub/controllers'
require 'rspec'
require 'rack/test'