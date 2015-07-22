namespace :servers do
  desc 'Update available servers'
  task update_streamers: :environment do
    StreamerWorker.update_streamers
  end
end

