class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :label
      t.string :displayable_name

      t.timestamps
    end

    add_column :documents, :category_id, :integer
    old_categories = [:colles, :info, :devoirs, :corrections]

    old_categories.each do |cat, index|
      category = Category.create!(label: cat, displayable_name: cat)
      Document.where(category: index).update_all category_id: category.id
    end

    remove_column :documents, :category, :integer
  end
end
