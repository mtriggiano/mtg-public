# config valid for current version and patch releases of Capistrano
lock ">=3.12.1"

set :application, "sgmagnus"
set :repo_url, "git@github.com:elorenzo368/magnus.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, -> { "/home/facundo/#{fetch(:application)}_#{fetch(:stage)}" }

set :rbenv_ruby, '2.6.3'

set :rbenv_custom_path, '/home/facundo/.rbenv'

set :rbenv_map_bins, %w{rake gem bundle ruby rails}

set :linked_files, %w{config/master.key}

set :unicorn_workers, 1

set :keep_releases, 1

set :master_key_local_path, "config/master.key"


# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
#set :local_user, 'facundo'

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
set :ssh_options, verify_host_key: :always

# Runs rake assets:clean
# Defaults to nil (no asset cleanup is performed)
# If you use Rails 4+ and you'd like to clean up old assets after each deploy,
# set this to the number of versions to keep
set :keep_assets, 2
set :user, 'facundo'
set :ssh_options, user: fetch(:user)

# Clear existing task so we can replace it rather than "add" to it.
namespace :rake do  
  desc "Run a task on a remote server."  
  # run like: cap staging rake:invoke task=a_certain_task  
  task :invoke do  
    run("cd #{deploy_to}/current; /usr/bin/env rake #{ENV['task']} RAILS_ENV=#{rails_env}")  
  end  
end
