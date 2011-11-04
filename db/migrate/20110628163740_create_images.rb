class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.references :photo
      t.references :user
      t.references :news_data

      t.string :image
      t.string :title
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
