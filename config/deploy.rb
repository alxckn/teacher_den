# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "teacher_den"
set :repo_url, "https://github.com/alxckn/teacher_den.git"
set :ssh_options, { user: "ubuntu" }

set :rvm_ruby_version, "2.6.2"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, ENV["BRANCH"] unless ENV["BRANCH"].nil?

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/srv/#{fetch(:application)}"

# Default value for :linked_files is []
append :linked_files, ".env"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", ".bundle", "public/system", "public/uploads", "public/assets", "storage"

# Default value for keep_releases is 5
set :keep_releases, 2

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

namespace :backup do
  desc "Backup DB and application"
  task :run do
    on roles(:app) do
      within "#{current_path}" do
        with rails_env: "#{fetch(:stage)}" do
          execute :bundle, "exec backup perform -t td_backup -c config/backup/config.rb"
        end
      end
    end
  end

  desc "Downloads the last backup"
  task :download_last, :local_dir do |task, args|
    args.with_defaults local_dir: "backups/"
    dir = "~/backups/td_backup/"
    pwd = nil
    last = nil
    on roles(:app) do
      within dir do
        pwd = capture(:pwd)
        last = capture(:ls).split(" ").sort.last
      end
      download_from = File.join(pwd, last)
      download_to = args[:local_dir]
      system "mkdir", "-p", download_to
      download! download_from, download_to, recursive: true
    end
  end

  task :run_then_download, :local_dir do |task, args|
    invoke "backup:run"
    invoke "backup:download_last", args[:local_dir]
  end
end
