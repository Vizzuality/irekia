class CreateAnswerUsers < ActiveRecord::Migration
  def self.up
    create_table :answer_users do |t|
      t.references :answer
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :answer_users
  end
end
