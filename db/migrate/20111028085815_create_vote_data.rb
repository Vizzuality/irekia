class CreateVoteData < ActiveRecord::Migration
  def self.up
    create_table :vote_data do |t|
      t.references :vote

      t.boolean :in_favor, :default => true

      t.timestamps
    end

    add_index :vote_data, :vote_id
  end

  def self.down
    drop_table :vote_data
  end
end
