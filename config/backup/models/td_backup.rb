# encoding: utf-8
require_relative "../../environment"

##
# Backup Generated: td_backup
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t td_backup [-c <path_to_configuration_file>]
#
# For more information about Backup's components, see the documentation at:
# http://backup.github.io/backup
#
Model.new(:td_backup, 'Description for td_backup') do
  ##
  # Archive [Archive]
  #
  # Adding a file or directory (including sub-directories):
  #   archive.add "/path/to/a/file.rb"
  #   archive.add "/path/to/a/directory/"
  #
  # Excluding a file or directory (including sub-directories):
  #   archive.exclude "/path/to/an/excluded_file.rb"
  #   archive.exclude "/path/to/an/excluded_directory
  #
  # By default, relative paths will be relative to the directory
  # where `backup perform` is executed, and they will be expanded
  # to the root of the filesystem when added to the archive.
  #
  # If a `root` path is set, relative paths will be relative to the
  # given `root` path and will not be expanded when added to the archive.
  #
  # archive.root Rails.root.to_s

  archive :documents do |archive|
    # Run the `tar` command using `sudo`
    # archive.use_sudo
    archive.add File.join(Rails.root, "public/system/")
    archive.add File.join(Rails.root, "storage")
    archive.tar_options "-h --xattrs"
  end

  ##
  # PostgreSQL [Database]
  #
  database PostgreSQL do |db|
    config = Rails.configuration.database_configuration
    db.name               = config[Rails.env]["database"]
    db.username           = config[Rails.env]["username"]
    db.password           = config[Rails.env]["password"]
    db.host               = config[Rails.env]["host"]
    db.port               = config[Rails.env]["port"]
    # db.socket             = "/tmp/pg.sock"
    db.additional_options = ["-xc", "-E=utf8"]
  end

  ##
  # Local (Copy) [Storage]
  #
  store_with Local do |local|
    local.path       = "~/backups/"
    local.keep       = 5
    # local.keep       = Time.now - 2592000 # Remove all backups older than 1 month.
  end

  ##
  # Gzip [Compressor]
  #
  compress_with Gzip

  after do |exit_status|
    callback_command = ENV["BACKUP_CALLBACK"]

    if Rails.configuration.try(:backup_with_callback) && callback_command && exit_status < 2 # complete success or success with warnings
      Logger.info "Uploading backups to the cloud"

      backed_up_path = self.storages
                         .find { |s| s.send(:storage_name) == "Storage::Local" }
                         .send(:remote_path)

      interpolation_vars = { backed_up_path: backed_up_path, time: self.time }

      # execute callback to sync to the cloud for instance
      # `rclone copy %{backed_up_path} pcloud:td_backup/%{time}`
      callback_command = callback_command % interpolation_vars
      Logger.info "Uploading using command: '#{callback_command}'"
      result = system(callback_command)

      result ? Logger.info("Callback command successful") : Logger.error("Command execution failed")
    else
      Logger.warn "Not running callback command: Rails is not configured or there was a previous error in the backup process"
      Logger.warn "Make sure you configured a rclone command with environment variable 'BACKUP_CALLBACK'"
      Logger.warn "Make sure backup callback is enabled within Rails config"
    end
  end
end
