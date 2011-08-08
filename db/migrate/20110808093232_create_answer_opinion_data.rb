class CreateAnswerOpinionData < ActiveRecord::Migration
  def self.up
    create_table :answer_opinion_data do |t|
      t.references :answer_opinion
      t.boolean :satisfactory, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :answer_opinion_data
  end
end
