Dir[File.join(File.dirname(__FILE__), 'kubernetes_deploy', '*.rb')].each do |file|
  require_relative File.join('kubernetes_deploy', File.basename(file, '.rb'))
end