class CreateArgumentData < ActiveRecord::Migration
  def self.up
    create_table :argument_data do |t|
      t.references :argument

      t.boolean :in_favor, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :argument_data
  end
end
