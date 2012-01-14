xml.channel do
  xml.atom :link, nil, {
    :href => root_url(:format => 'rss'),
    :rel => 'self', :type => 'application/rss+xml'
  }

  xml.title "Irekia"
  xml.description "Euskadi Open Government"
  xml.link root_url(:format => 'rss')

  for action in @rss_actions
    xml.item do
      xml.title t(".rss.items.title.#{action.type}", :text => action.text)
      xml.description action.body
      xml.pubDate action.published_at.to_s(:rfc822)
      xml.link send("#{action.type}_url", action.id)
      xml.guid send("#{action.type}_url", action.id)
    end
  end
end
