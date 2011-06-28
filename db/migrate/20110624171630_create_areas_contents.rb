class CreateAreasContents < ActiveRecord::Migration
  def self.up
    create_table :areas_contents do |t|
      t.references :area
      t.references :content

      t.timestamps
    end
  end

  def self.down
    drop_table :areas_contents
  end
end
