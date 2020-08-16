class AddNoteToDocuments < ActiveRecord::Migration[5.2]
  def change
    add_column :documents, :note, :text
  end
end
