class CreateQuestionData < ActiveRecord::Migration
  def self.up
    create_table :question_data do |t|
      t.references :question
      t.references :user
      t.references :area

      t.text     :question_text
      t.text     :body
      t.datetime :answered_at

      t.timestamps
    end

    add_index :question_data, :question_id
  end

  def self.down
    drop_table :question_data
  end
end
