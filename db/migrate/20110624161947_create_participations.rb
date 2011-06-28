class CreateParticipations < ActiveRecord::Migration
  def self.up
    create_table :participations do |t|
      t.references :user
      t.references :content

      t.string :name
      t.string :type
      t.datetime :published_at

      t.timestamps
    end
  end

  def self.down
    drop_table :participations
  end
end
