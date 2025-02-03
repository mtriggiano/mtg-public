require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Magnus
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.active_job.queue_adapter = :delayed_job

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    # Don't generate system test files.
    config.generators.system_tests = nil
    config.generators.javascript_engine = :js
    config.i18n.default_locale = :'es'
    config.time_zone = "America/Argentina/Buenos_Aires"
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '*/')]
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '*/*/')]
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '*/*/*/')]
    config.autoload_paths -= Dir[Rails.root.join('app', 'models', 'file', 'general')]
    config.autoload_paths -= Dir[Rails.root.join('app', 'models', 'file', 'surgeries/')]
    config.autoload_paths -= Dir[Rails.root.join('app', 'models', 'file', 'sales/')]
    config.autoload_paths += Dir[Rails.root.join('app', 'models', 'finance')]
    config.autoload_paths += Dir[Rails.root.join('app', 'controllers', '*/*/')]
    config.autoload_paths += Dir[Rails.root.join('app', 'controllers', '*/')]
    config.autoload_paths += Dir[Rails.root.join('app', 'presenters', '{**}')]
    config.autoload_paths += Dir[Rails.root.join('app', 'datatables', '*/')]
    config.autoload_paths += Dir[Rails.root.join('app', 'services', '*')]
    config.autoload_paths += Dir[Rails.root.join('app', 'services', '*/*')]
    config.autoload_paths += Dir[Rails.root.join('app', 'services', '*/*/')]
    config.autoload_paths += Dir[Rails.root.join('app', 'validators', '*/')]
    config.autoload_paths += Dir[Rails.root.join('lib')]
    config.autoload_paths += Dir[Rails.root.join('lib/anmat')]

    config.to_prepare do
        Devise::Mailer.layout "mailer"
    end
    
  end
end
