class CreateAnswerData < ActiveRecord::Migration
  def self.up
    create_table :answer_data do |t|
      t.references :answer
      t.references :question
      t.references :user

      t.text :answer_text

      t.timestamps
    end

    add_index :answer_data, :answer_id
  end

  def self.down
    drop_table :answer_data
  end
end
