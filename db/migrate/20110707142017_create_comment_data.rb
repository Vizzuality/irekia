class CreateCommentData < ActiveRecord::Migration
  def self.up
    create_table :comment_data do |t|
      t.references :comment
      t.string :subject
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :comment_data
  end
end
