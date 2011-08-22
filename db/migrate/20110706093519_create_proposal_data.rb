class CreateProposalData < ActiveRecord::Migration
  def self.up
    create_table :proposal_data do |t|
      t.references :proposal
      t.references :user
      t.references :area

      t.string :title
      t.text :body
      t.boolean :close, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :proposal_data
  end
end
