class InitGlobalVars < ActiveRecord::Migration[5.2]
  class GlobalVar < ApplicationRecord; end

  def up
    defaults = YAML.load_file(Rails.root.join("config", "vars_defaults.yml")).with_indifferent_access
    vars = defaults[:vars]

    if vars && ActiveRecord::Base.connection.data_source_exists?("global_vars")
      persisted_vars = GlobalVar.all
      missing_keys = vars.keys - persisted_vars.map(&:key)

      missing_keys.each do |key|
        GlobalVar.create(key: key, value: vars[key])
      end
    end
  end
end
