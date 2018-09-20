Dir[File.join(File.dirname(__FILE__), 'drscan', '*.rb')].each do |file|
  require_relative File.join('drscan', File.basename(file, '.rb'))
end