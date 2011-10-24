class CreateParticipations < ActiveRecord::Migration
  def self.up
    create_table :participations do |t|
      t.references :user
      t.references :content

      t.string   :name
      t.string   :type
      t.datetime :published_at
      t.boolean  :moderated, :default => false

      t.timestamps
    end

    add_index :participations, :type
    add_index :participations, :published_at
    add_index :participations, :moderated
  end

  def self.down
    drop_table :participations
  end
end
