class CreateParticipations < ActiveRecord::Migration
  def self.up
    create_table :participations do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :participations
  end
end
