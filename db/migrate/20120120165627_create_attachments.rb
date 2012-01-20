class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.references :content
      t.string :type
      t.string :name
      t.string :url
      t.string :file_type
      t.string :size

      t.timestamps
    end
  end

  def self.down
    drop_table :attachments
  end
end
