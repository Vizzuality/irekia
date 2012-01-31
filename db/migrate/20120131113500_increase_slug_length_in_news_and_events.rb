class IncreaseSlugLengthInNewsAndEvents < ActiveRecord::Migration
  def self.up
    change_column :contents, :slug, :string, :length => 1000
  end

  def self.down
    change_column :contents, :slug, :string
  end
end
