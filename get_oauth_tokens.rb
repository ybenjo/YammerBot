# -*- coding: utf-8 -*-
require "oauth"
require "pp"
require "yammer"
require "yaml"

configs = { }
if File.exist?("./config/yammer_config.yaml")
  configs = YAML.load_file("./config/yammer_config.yaml")
  configs.each_pair do |k, v|
    configs[k.to_sym] = v
  end
else
  print "Input consumer_key: "
  configs[:consumer_key] = STDIN.gets.chomp
  print "Input consumer_secret: "
  configs[:consumer_secret] = STDIN.gets.chomp
  
  consumer = OAuth::Consumer.new(
                                 configs[:consumer_key],
                                 configs[:consumer_secret],
                                 :site => "https://www.yammer.com"
                                 )
  
  request = consumer.get_request_token()
  
  request_token = request.token
  
  puts "https://www.yammer.com/oauth/authorize?oauth_token=#{request_token}"
  print "Input PIN code: "
  pin = STDIN.gets.chomp
  
  access = request.get_access_token(:oauth_verifier => pin)
  
  configs[:oauth_token] = access.token
  configs[:oauth_token_secret] = access.secret

  open("./config/yammer_config.yaml", "w"){|f|
    f.puts configs.to_yaml
  }
end

