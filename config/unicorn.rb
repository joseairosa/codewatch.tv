RAILS_ROOT = File.expand_path('../../',  __FILE__)

worker_processes 3
timeout 30
preload_app true
listen '127.0.0.1:8080'
user (ENV['RACK_ENV'] == 'development' ? ENV['USER'] : 'rails')
working_directory '/home/rails'
pid '/home/rails/pids/unicorn.pid'
stderr_path '/home/rails/log/unicorn.log'
stdout_path '/home/rails/log/unicorn.log'

preload_app true

unless ENV['RACK_ENV'] == 'development'
  # Reset BUNDLE_GEMFILE on each load in sandboxed environments
  # http://unicorn.bogomips.org/Sandbox.html
  before_exec do |server|
    ENV['BUNDLE_GEMFILE'] = File.expand_path('Gemfile', RAILS_ROOT)
  end
end

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  # require 'bunny'
  #
  # defined?(ActiveRecord::Base) and
  #     ActiveRecord::Base.establish_connection
  #
  # QUEUE_CONNECTION.start
end
