class AddMoreTranslationFieldsForAreasAndUsers < ActiveRecord::Migration

  def self.up
    add_column :areas, :description_1_es, :text
    add_column :areas, :description_1_eu, :text
    add_column :areas, :description_1_en, :text
    add_column :areas, :description_2_es, :text
    add_column :areas, :description_2_eu, :text
    add_column :areas, :description_2_en, :text

    add_column :users, :description_1_es, :text
    add_column :users, :description_1_eu, :text
    add_column :users, :description_1_en, :text
    add_column :users, :description_2_es, :text
    add_column :users, :description_2_eu, :text
    add_column :users, :description_2_en, :text
  end

  def self.down
    remove_column :areas, :description_1_es
    remove_column :areas, :description_1_eu
    remove_column :areas, :description_1_en
    remove_column :areas, :description_2_es
    remove_column :areas, :description_2_eu
    remove_column :areas, :description_2_en

    remove_column :users, :description_1_es
    remove_column :users, :description_1_eu
    remove_column :users, :description_1_en
    remove_column :users, :description_2_es
    remove_column :users, :description_2_eu
    remove_column :users, :description_2_en
  end
end
