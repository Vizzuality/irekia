module Admin::ModerationHelper
  include ApplicationHelper

  def render_item_for_moderation(item)
    item_type = item.class.name.downcase
    user      = item.respond_to?(:users) ? item.users.first : item.user
    footer    = content_author(user, item.published_at, item_type)

    send("render_#{item_type}", item, footer, item_type)
  rescue
    nil
  end
end