class Title < ActiveRecord::Base
  serialize :translated_name

  has_many :users


  def get_translated_name
    translated_name[I18n.locale.to_s] if translated_name.present?
  end
end
