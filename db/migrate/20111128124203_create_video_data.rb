class CreateVideoData < ActiveRecord::Migration
  def self.up
    create_table :video_data do |t|
      t.references :video
      t.references :answer_data

      t.string :title
      t.string :description
      t.string :youtube_url
      t.string :vimeo_url
      t.string :thumbnail_url
      t.text   :html

      t.timestamps
    end
  end

  def self.down
    drop_table :video_data
  end
end
