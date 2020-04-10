class RemoveAdminRole < ActiveRecord::Migration[5.0]
  class Admin < ApplicationRecord; end

  def change
    add_column :users, :admin, :boolean, default: false
    reversible do |dir|
      dir.up do
        Admin.find_each do |admin|
          user = User.new(email: admin.email, encrypted_password: admin.encrypted_password, admin: true)
          user.save!(validate: false)
        end
      end
    end
  end
end
