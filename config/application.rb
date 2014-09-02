require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SocialApp
  class Application < Rails::Application

    config.assets.precompile += [lambda do |filename, path|
      path =~ /assets\/images/ && !%w(.js .css).include?(File.extname(filename))
    end]

    config.assets.precompile += ['jquery-2.1.1.min.js','jquery.wallform.js','common.css','home.js','classes/user.js','edit.js','edit.css','home.css','posts.css','posts.js',"search.css"]


  end
end
