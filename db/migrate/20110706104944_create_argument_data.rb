class CreateArgumentData < ActiveRecord::Migration
  def self.up
    create_table :argument_data do |t|
      t.references :argument

      t.boolean :in_favor, :default => true
      t.string :reason

      t.timestamps
    end

    add_index :argument_data, :argument_id
  end

  def self.down
    drop_table :argument_data
  end
end
