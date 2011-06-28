class CreateArguments < ActiveRecord::Migration
  def self.up
    create_table :arguments do |t|
      t.references :proposal
      t.text :body
      t.boolean :in_favor

      t.timestamps
    end
  end

  def self.down
    drop_table :arguments
  end
end
