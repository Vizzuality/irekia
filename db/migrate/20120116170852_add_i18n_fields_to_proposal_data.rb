class AddI18nFieldsToProposalData < ActiveRecord::Migration
  def self.up
    remove_column :proposal_data, :title
    remove_column :proposal_data, :body
    add_column :proposal_data, :title_es, :string
    add_column :proposal_data, :title_eu, :string
    add_column :proposal_data, :title_en, :string
    add_column :proposal_data, :body_es, :text
    add_column :proposal_data, :body_eu, :text
    add_column :proposal_data, :body_en, :text
    add_column :proposal_data, :external_id, :string
  end

  def self.down
    add_column :proposal_data, :title, :string
    add_column :proposal_data, :body, :text
    remove_column :proposal_data, :title_es
    remove_column :proposal_data, :title_eu
    remove_column :proposal_data, :title_en
    remove_column :proposal_data, :body_es
    remove_column :proposal_data, :body_eu
    remove_column :proposal_data, :body_en
    remove_column :proposal_data, :external_id
  end
end
