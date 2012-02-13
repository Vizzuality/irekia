class AddI18nFieldsToEventData < ActiveRecord::Migration
  def self.up
    add_column :event_data, :title_es, :string
    add_column :event_data, :title_eu, :string
    add_column :event_data, :title_en, :string
    add_column :event_data, :body_es, :text
    add_column :event_data, :body_eu, :text
    add_column :event_data, :body_en, :text
  end

  def self.down
    remove_column :event_data, :body_en
    remove_column :event_data, :body_eu
    remove_column :event_data, :body_es
    remove_column :event_data, :title_en
    remove_column :event_data, :title_eu
    remove_column :event_data, :title_es
  end
end
