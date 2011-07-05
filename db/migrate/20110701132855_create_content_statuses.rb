class CreateContentStatuses < ActiveRecord::Migration
  def self.up
    create_table :content_statuses do |t|
      t.string :name
      t.string :name_i18n_key

      t.timestamps
    end
  end

  def self.down
    drop_table :content_statuses
  end
end
