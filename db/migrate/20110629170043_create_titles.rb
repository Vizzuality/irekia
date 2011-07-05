class CreateTitles < ActiveRecord::Migration
  def self.up
    create_table :titles do |t|
      t.string :name
      t.string :name_i18n_key

      t.timestamps
    end
  end

  def self.down
    drop_table :titles
  end
end
