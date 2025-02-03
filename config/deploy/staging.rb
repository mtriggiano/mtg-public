server "35.193.88.75", user: "facundo", roles: %w{app db web}
set :nginx_server_name, 'test.magnus.litecodecloud.com'
set :delayed_job_workers, 1
set :delayed_job_pid_dir, '/tmp'

set :pg_generate_random_password, true