class CreateAreasContents < ActiveRecord::Migration
  def self.up
    create_table :areas_contents do |t|
      t.integer :area_id
      t.integer :content_id

      t.timestamps
    end
  end

  def self.down
    drop_table :areas_contents
  end
end
