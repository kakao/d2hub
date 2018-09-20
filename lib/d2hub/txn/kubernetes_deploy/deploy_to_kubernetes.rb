require_relative '../transaction'
require 'rest-client'
require 'kubernetes'
require 'kubernetes/utils'

module D2HUB
  class DeployToKubernetes < Transaction
    def run(jobSpec: nil)
      Kubernetes.configure do |config|
        config.api_key_prefix['authorization'] = 'Bearer'
        config.api_key['authorization'] = "#{ENV['KUBERNETES_TOKEN']}"
        config.host = ENV['KUBERNETES_HOST']
        config.scheme = 'https'
        config.verify_ssl = false
        config.verify_ssl_host = false
      end

      api_instance = Kubernetes::BatchV1Api.new
      api_instance.api_client.config.verify_ssl_host = false
      namespace = ENV['KUBERNETES_NAMESPACE'] || "default"
      body = Kubernetes::V1Job.new(jobSpec) # V1Job |

      opts = {
          pretty: "true",
      }

      begin
        result = api_instance.create_namespaced_job(namespace, body, opts)
        STDERR.print(result)
      rescue Kubernetes::ApiError => e
        STDERR.print("Exception when calling BatchV1Api->create_namespaced_job: #{e}")
      end
    end
  end
end
