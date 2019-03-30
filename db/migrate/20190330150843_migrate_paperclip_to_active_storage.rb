class MigratePaperclipToActiveStorage < ActiveRecord::Migration[5.2]
  class ActiveStorageDocument < ApplicationRecord
    self.table_name = "documents"

    has_one_attached :file
  end

  class PaperclipDocument < ApplicationRecord
    self.table_name = "documents"

    has_secure_token
    has_attached_file :file,
      url: "/system/documents/:token/:style/:filename",
      path: ":rails_root/public:url"
    do_not_validate_attachment_file_type :file
    Paperclip.interpolates :token do |attachment, style|
      attachment.instance.token
    end
  end

  def up
    ActiveStorage::Attachment.delete_all

    PaperclipDocument.where.not(file_file_name: nil).find_each do |document|
      file = document.file

      as_document = ActiveStorageDocument.find(document.id)
      as_document.file.attach(io: File.open(file.path),
                              filename: document.file_file_name,
                              content_type: document.file_content_type)
    end

    ActiveStorage::Attachment.update_all record_type: "Document"
  end
end
