class CreatePollAnswerUsers < ActiveRecord::Migration
  def self.up
    create_table :poll_answer_users do |t|
      t.references :poll_answer
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :poll_answer_users
  end
end
