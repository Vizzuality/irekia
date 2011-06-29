class AddSexAndTitleToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.references :sex
      t.references :title
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :sex
      t.remove :title
    end
  end
end
