ActiveSupport::Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
  inflect.plural /^area_content$/i, 'areas_contents'
  inflect.singular /^areas_contents$/i, 'area_content'
  inflect.plural /^content_user$/i, 'contents_users'
  inflect.singular /^contents_users$/i, 'content_user'
end
