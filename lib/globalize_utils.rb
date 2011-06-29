# encoding: UTF-8
module GlobalizeUtils
  extend ActiveSupport::Concern

  module ClassMethods
    def where_translation(translations)
      joins(<<-SQL
        INNER JOIN #{translations_table_name} ON #{table_name}.id = #{translations_table_name}.#{table_name.singularize}_id
      SQL
      )
      .where(translations_table_name => translations)
      .readonly(false)
    end

    def translations_for(translations, &block)
      translation_scope = where_translation(translations)
      yield(translation_scope.first || self.new) if block_given?
    end

    def add_translation( locale, translations = {})
      I18n.with_locale locale do
        translations[:locale] = I18n.locale
        return if self.where_translation(translations).present?
        self.first.update_attributes!(translations)
      end
    end
  end

  module InstanceMethods
    def add_translation( locale, translations = {} )
      I18n.with_locale locale do
        update_attributes!(translations)
        reload
      end
    end
  end

end

class ActiveRecord::Base
  include GlobalizeUtils
end