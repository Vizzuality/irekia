class CreateSexes < ActiveRecord::Migration
  def self.up
    create_table :sexes do |t|
      t.string :name

      t.timestamps
    end
    Sex.create_translation_table! :name => :string
  end

  def self.down
    drop_table :sexes
    Sex.drop_translation_table!
  end
end
