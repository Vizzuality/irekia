module ApplicationHelper

  def am_I?(user)
    current_user && user && current_user.try(:id) == user.try(:id)
  end

  def current_area?(area)
    area.eql?(@area) ? 'selected' : nil
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def viewing_dashboard?
    controller_name == 'users' && action_name == 'show' && current_user && params[:id].to_i == current_user.id
  end

  def viewing_politician_dashboard?
    controller_name == 'politicians' && action_name == 'show' && current_user && params[:id].to_i == current_user.id && current_user.is_politician
  end

  def viewing_private_activity?
    controller_name == 'users' && action_name == 'actions' && current_user && params[:id].to_i == current_user.id
  end

  def viewing_public_profile?
    controller_name == 'users' && action_name == 'show' && ((current_user && params[:id].to_i != current_user.id) || current_user.blank?)
  end

  def current_action?(action)
    'selected' if action_name.eql?(action.to_s)
  end

  def translates_model_value(model, key)
    t([model.class.name.downcase, key, model["#{key}_i18n_key"]].join('.'), :scope => 'activerecord.values')
  end

  def get_politician_title(user)
    translates_model_value(user.title, :name)[user.is_woman?? :female : :male] if user.title
  end

  def menu(options)
    render 'shared/menu', :options => options
  end

  def path_for_user(user, params = {})
    if user.is_politician
      politician_path(user.id, params)
    else
      user_path(user.id, params)
    end
  end

  def avatar(user_or_area, size = nil)
    size = size.present?? size.to_s : ''

    if user_or_area.is_a?(Area)
      area = user_or_area
      if area.present? && area.image.present?
        link_to (image_tag(area.thumbnail) + (raw(content_tag :div, " ", :class => :ieframe))), area_path(area), :title => area.name, :class => "avatar #{size}"
      end
    else
      if user_or_area.present? && user_or_area.profile_image.present?
        user = user_or_area
        link_to (image_tag(user.profile_image) + (raw(content_tag :div, " ", :class => :ieframe))), path_for_user(user), :title => user.fullname, :class => "avatar #{size}"
      elsif user_or_area.present? && user_or_area.thumbnail.present?
        area = user_or_area
        link_to (image_tag(area.thumbnail) + (raw(content_tag :div, " ", :class => :ieframe))), area_path(area.id), :title => area.name, :class => "avatar #{size}"
      else
        image_tag 'icons/faceless_avatar.png', :class => "avatar #{size}", :title => t('unknown_user')
      end
    end
  end

  def only_logged_class
    :only_logged unless user_signed_in?
  end

  def within_the_day?(comments)
    last_comment = comments.last
    # Since last_comment is a deserialized JSON object using the JSON.parse method, dates aren't
    # parsed as Date objects but Strings. We could use ActiveSupport::JSON.decode method, but since it
    # is 20.000x slower than JSON.parse, we prefer to just convert values as need
    comment_date = last_comment.published_at
    comment_date = DateTime.parse(comment_date) if comment_date.is_a?(String)
    comment_date > 2.day.ago
  end

  def show_last_comments?(content)
    content.last_comments.present? && within_the_day?(content.last_comments)
  end

  def button(value=nil, options={})
    content_tag :button, :type => :submit, :class => options[:class] do
      content_tag :span, value
    end
  end
  def button_with_login(value=nil, options={})
    options[:class] = "floating-login #{options[:class]}" unless current_user
    content_tag :button, :type => :submit, :class => options[:class] do
      content_tag :span, value
    end
  end

  def link_to_with_login(*args)
    html_options = args[2] || {}
    html_options[:class] = "floating-login #{html_options[:class]}" unless user_signed_in?
    html_options[:class].gsub!('after_', '') if user_signed_in?
    args[2] = html_options
    link_to(*args)
  end

  def class_for_after_login
    'after_' unless user_signed_in?
  end

  def class_for_modal_login
    'floating-login' unless user_signed_in?
  end

  def notifications_count
    user_signed_in?? current_user.notifications_count : 0
  end

  def notifications_list
    user_signed_in?? current_user.notifications_grouped : []
  end

  def render_notification_item(notification, li_class = nil)
    case notification.item_type
    when 'Follow'
      content_tag :li, raw(t('.notifications.follow', :count => notification.count.to_i, :name => link_to(notification.parent.fullname, user_path(notification.parent)))), :class => li_class
    when 'Answer'
      content_tag :li, raw(t('.notifications.answer', :count => notification.count.to_i, :question => link_to(t('.notifications.your_content.question'), question_path(notification.parent)))), :class => li_class
    when 'Comment'

      i18n_key, i18n_scope = if notification.parent && notification.parent.author == current_user
        ['.notifications.comments_content_author', 'shared.nav_bar_buttons.notifications.your_content']
      else
        ['.notifications.comments_content', 'shared.nav_bar_buttons.notifications.a_content']
      end

      content_tag :li, raw(t(i18n_key, :count => notification.count.to_i, :content => link_to(t(notification.parent.class.name.underscore, :scope => i18n_scope).downcase, send("#{notification.parent.class.name.underscore}_path", notification.parent)))), :class => li_class
    when 'Argument'

      i18n_key, i18n_scope = if notification.parent && notification.parent.author == current_user
        ['.notifications.argument_proposal_author', 'shared.nav_bar_buttons.notifications.your_content']
      else
        ['.notifications.argument_proposal', 'shared.nav_bar_buttons.notifications.a_content']
      end

      content_tag :li, raw(t(i18n_key, :count => notification.count.to_i, :content => link_to(t(notification.parent.class.name.underscore, :scope => i18n_scope).downcase, send("#{notification.parent.class.name.underscore}_path", notification.parent)))), :class => li_class
    when 'Vote'

      i18n_key, i18n_scope = if notification.parent && notification.parent.author == current_user
        ['.notifications.vote_proposal_author', 'shared.nav_bar_buttons.notifications.your_content']
      else
        ['.notifications.vote_proposal', 'shared.nav_bar_buttons.notifications.a_content']
      end

      content_tag :li, raw(t(i18n_key, :count => notification.count.to_i, :content => link_to(t(notification.parent.class.name.underscore, :scope => i18n_scope).downcase, send("#{notification.parent.class.name.underscore}_path", notification.parent)))), :class => li_class
    when 'ContentUser'

      i18n_scope = if notification.parent && notification.parent.author == current_user
        'shared.nav_bar_buttons.notifications.your_content'
      else
        'shared.nav_bar_buttons.notifications.a_content'
      end

      content_tag :li, raw(t('.notifications.content_users', :count => notification.count.to_i, :content => link_to(t(notification.parent.class.name.underscore, :scope => i18n_scope).downcase, send("#{notification.parent.class.name.underscore}_path", notification.parent)))), :class => li_class
    end
  rescue
  end

  def image_url(image_path)
    request.protocol + request.host_with_port + image_path
  end
end

