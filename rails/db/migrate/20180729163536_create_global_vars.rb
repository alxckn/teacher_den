class CreateGlobalVars < ActiveRecord::Migration[5.0]
  def change
    create_table :global_vars do |t|
      t.string :key, unique: true
      t.string :value
    end
  end
end
