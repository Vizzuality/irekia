class CreateNewsData < ActiveRecord::Migration
  def self.up
    create_table :news_data do |t|
      t.references :news
      t.references :image

      t.string :title
      t.string :subtitle
      t.text :body

      t.timestamps
    end

    add_index :news_data, :news_id
  end

  def self.down
    drop_table :news_data
  end
end
