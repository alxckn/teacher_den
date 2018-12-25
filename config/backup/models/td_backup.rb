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

end