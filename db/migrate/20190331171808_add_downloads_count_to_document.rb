class AddDownloadsCountToDocument < ActiveRecord::Migration[5.2]
  def change
    add_column :documents, :downloads_count, :integer, default: 0
    add_column :documents, :last_downloaded_at, :datetime
  end
end
