xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Irekia"
    xml.description "A blog about software and chocolate"
    xml.link root_url

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
end
