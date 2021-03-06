# https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server

workers Integer(ENV['WEB_CONCURRENCY'] || 4)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
environment ENV['RAILS_ENV'] || 'development'

ssl_bind '0.0.0.0', '4100', {
    key: "/etc/ssl/yacs/privkey.pem",
    cert: "/etc/ssl/yacs/cert.pem"
}

pidfile "/var/run/puma/puma.pid"
state_path "/var/run/puma/puma.state"

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end
