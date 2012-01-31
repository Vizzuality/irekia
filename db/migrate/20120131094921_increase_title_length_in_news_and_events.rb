class IncreaseTitleLengthInNewsAndEvents < ActiveRecord::Migration
  def self.up
    change_column :news_data,       :title_es,  :string, :length => 1000
    change_column :news_data,       :title_eu,  :string, :length => 1000
    change_column :news_data,       :title_en,  :string, :length => 1000
    change_column :proposal_data,   :title_es,  :string, :length => 1000
    change_column :proposal_data,   :title_eu,  :string, :length => 1000
    change_column :proposal_data,   :title_en,  :string, :length => 1000
  end

  def self.down
    change_column :news_data,       :title_es, :string
    change_column :news_data,       :title_eu, :string
    change_column :news_data,       :title_en, :string
    change_column :proposal_data,   :title_es, :string
    change_column :proposal_data,   :title_eu, :string
    change_column :proposal_data,   :title_en, :string
  end
end
