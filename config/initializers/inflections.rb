ActiveSupport::Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
  inflect.plural /^area_content$/i, 'areas_contents'
  inflect.singular /^areas_contents$/i, 'area_content'
  inflect.plural /^area_user$/i, 'areas_users'
  inflect.singular /^areas_users$/i, 'area_user'
  inflect.plural /^content_user$/i, 'contents_users'
  inflect.singular /^contents_users$/i, 'content_user'
  inflect.plural /^content_author$/i, 'contents_authors'
  inflect.singular /^contents_authors$/i, 'content_author'
  inflect.plural /^content_receiver$/i, 'contents_receivers'
  inflect.singular /^contents_receivers$/i, 'content_receiver'
  inflect.plural /^content_related_user$/i, 'contents_related_users'
  inflect.singular /^contents_related_users$/i, 'content_related_user'
end
