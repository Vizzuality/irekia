class CreateAnswerData < ActiveRecord::Migration
  def self.up
    create_table :answer_data do |t|
      t.references :answer
      t.references :question
      t.references :user

      t.text :answer_text

      t.timestamps
    end
  end

  def self.down
    drop_table :answer_data
  end
end
