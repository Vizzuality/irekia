class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.references :image_gallery
      t.references :user

      t.string :image

      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
