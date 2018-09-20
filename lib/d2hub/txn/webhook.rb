Dir[File.join(File.dirname(__FILE__), 'webhook', '*.rb')].each do |file|
  require_relative File.join('webhook', File.basename(file, '.rb'))
end

module D2HUB
  class WebhookHelper
    def self.parse_image_name(image_full_name)
      last_index = image_full_name.rindex(':')
      {name: image_full_name[0...last_index], tag: image_full_name[last_index+1..-1]}
    end
  end
end