class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name

      t.timestamps
    end
    Role.create_translation_table! :name => :string
  end

  def self.down
    drop_table :roles
    Role.drop_translation_table!
  end
end
