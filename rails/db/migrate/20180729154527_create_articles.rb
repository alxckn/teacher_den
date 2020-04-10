class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.references :parent, references: :articles

      t.boolean :private, default: false
      t.integer :status, default: 0
      t.string :title
      t.text :content
    end
  end
end
