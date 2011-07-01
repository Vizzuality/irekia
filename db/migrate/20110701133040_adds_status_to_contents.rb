class AddsStatusToContents < ActiveRecord::Migration
  def self.up
    change_table :contents do |t|
      t.references :content_status
    end
  end

  def self.down
    change_table :contents do |t|
      t.remove :content_status
    end
  end
end
