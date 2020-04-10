job_type :backup, "cd :path && :environment_variable=:environment bundle exec backup perform :task :output"

set :output, "/srv/teacher_den/shared/log/whenever.log"

every 1.day do
  backup "-t td_backup -c config/backup/config.rb"
end
