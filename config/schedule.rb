job_type :rake_env, "cd :path && RAILS_ENV=#{ENV['RAILS_ENV']} SEGMENT_IO_WRITE_KEY=#{ENV['SEGMENT_IO_WRITE_KEY']} bundle exec rake :task"

every 5.minutes do
  rake_env 'process:category_viewers'
end

every 5.minutes do
  rake_env 'process:update_reddit_feeds'
end

# every 1.minute do
#   rake 'statistics:online_streams'
# end
