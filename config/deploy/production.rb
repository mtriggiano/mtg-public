server "35.238.164.76", user: "facundo", roles: %w{app db web}
#server "34.122.191.137", user: "facundo", roles: %w{app db web}
set :nginx_server_name, 'magnus.litecodesas.com'
set :delayed_job_workers, 1
set :delayed_job_pid_dir, '/tmp'
set :console_env, :production
set :console_user, :facundo # run rails console as appuser through sudo
set :console_role, :app

set :pg_generate_random_password, true

set :logger_default_file, "#{deploy_to}/shared/log/production.log" # default <release_path>/log/<rails_env>.log
set :logger_lines, 500 # default 100
