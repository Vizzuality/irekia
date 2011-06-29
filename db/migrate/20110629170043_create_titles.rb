class CreateTitles < ActiveRecord::Migration
  def self.up
    create_table :titles do |t|
      t.string :name

      t.timestamps
    end
    Title.create_translation_table! :name => :string
  end

  def self.down
    drop_table :titles
    Title.drop_translation_table!
  end
end
