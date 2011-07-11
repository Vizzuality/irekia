class CreateNewsData < ActiveRecord::Migration
  def self.up
    create_table :news_data do |t|
      t.references :news

      t.string :title
      t.string :subtitle
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :news_data
  end
end
