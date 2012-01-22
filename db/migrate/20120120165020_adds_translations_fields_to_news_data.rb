class AddsTranslationsFieldsToNewsData < ActiveRecord::Migration
  def self.up
    add_column :news_data, :title_es, :string
    add_column :news_data, :title_eu, :string
    add_column :news_data, :title_en, :string
    add_column :news_data, :body_es, :text
    add_column :news_data, :body_eu, :text
    add_column :news_data, :body_en, :text
  end

  def self.down
    remove_column :news_data, :title_es
    remove_column :news_data, :title_eu
    remove_column :news_data, :title_en
    remove_column :news_data, :body_es
    remove_column :news_data, :body_eu
    remove_column :news_data, :body_en
  end
end
