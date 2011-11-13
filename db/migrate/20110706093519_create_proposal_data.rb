class CreateProposalData < ActiveRecord::Migration
  def self.up
    create_table :proposal_data do |t|
      t.references :proposal
      t.references :area

      t.string  :title
      t.text    :body
      t.boolean :close,         :default => false
      t.integer :participation, :default => 0
      t.integer :in_favor,      :default => 0
      t.integer :against,       :default => 0

      t.timestamps
    end

    add_index :proposal_data, :proposal_id
  end

  def self.down
    drop_table :proposal_data
  end
end
