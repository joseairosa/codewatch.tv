every 5.minutes do
  rake 'process:category_viewers'
end

every 5.minutes do
  rake 'statistics:update_reddit_feeds'
end

every 1.minute do
  rake 'statistics:online_users'
  rake 'statistics:online_streams'
end
