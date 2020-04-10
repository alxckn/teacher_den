class DocumentsController < ApplicationController
  before_action :check_user_authentication

  def download
    document.with_lock do
      document.downloads_count += 1
      document.last_downloaded_at = Time.now.utc
      document.save!
    end

    send_data(
      document.file.download,
      filename: document.file.filename.to_s,
      content_type: document.file.content_type,
      disposition: :inline
    )
  end

  private

  def check_user_authentication
    authenticate_user! unless document.public?
  end

  def document
    @document ||= Document.includes(:category).find params[:download_id]
  end
end
