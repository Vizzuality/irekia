class CreateQuestionData < ActiveRecord::Migration
  def self.up
    create_table :question_data do |t|
      t.references :question
      t.references :user
      t.references :area

      t.text :question_text

      t.timestamps
    end
  end

  def self.down
    drop_table :question_data
  end
end
