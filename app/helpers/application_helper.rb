module ApplicationHelper

  def page_title
    'IREKIA'
  end

  def available_locales
    [:es, :eu, :en]
  end

  def homepage?
    controller_name == 'home' && action_name == 'index'
  end

  def am_I?(user)
    current_user && user && current_user.try(:id) == user.try(:id) && (private_profile? || politician_profile?)
  end

  def private_profile?
    @viewing_access == 'private'
  end

  def politician_profile?
    @viewing_access == 'politician'
  end

  def public_profile?
    @viewing_access == "public"
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
    controller_name == 'users' && action_name == 'show' && current_user && @user == current_user
  end

  def viewing_politician_dashboard?
    controller_name == 'politicians' && action_name == 'show' && current_user && @user == current_user && current_user.is_politician
  end

  def viewing_private_activity?
    controller_name == 'users' && action_name == 'actions' && current_user && @user == current_user
  end

  def viewing_public_profile?
    controller_name == 'users' && action_name == 'show' && (@user != current_user || current_user.blank?)
  end

  def current_action?(action)
    'selected' if action_name.eql?(action.to_s)
  end

  def translates_model_value(model, key)
    t([model.class.name.downcase, key, model["#{key}_i18n_key"]].join('.'), :scope => 'activerecord.values')
  end

  def get_politician_title(user)
    user.title.get_translated_name if user.title
  end

  def menu(options)
    render 'shared/menu', :options => options
  end

  def path_for_user(user, params = {})
    return '#' if user.id == User.wadus.id

    if user.is_politician
      politician_path(user.slug || user.id, params)
    else
      user_path(user.slug || user.id, params)
    end
  end

  def avatar(user_or_area, size = nil)
    avatar_html = image_tag "icons/faceless#{ "_#{size}" unless size.blank? }_avatar.png", :class => "avatar #{size}", :title => t('unknown_user')
    size = size.present?? size.to_s : ''

    if user_or_area.is_a?(Area)
      area = user_or_area
      if area.present? && area.image.present?
        avatar_html = link_to (image_tag(area.thumbnail) + (raw(content_tag :div, " ", :class => :ieframe))), area_path(area), :title => area.name, :class => "avatar #{size}"
      end
    else
      begin
        if user_or_area.present? && user_or_area.profile_image.present?
          user = user_or_area
          image_url = size == 'big' ? user.profile_image_big : user.profile_image
          avatar_html = link_to (image_tag(image_url) + (raw(content_tag :div, " ", :class => :ieframe))), path_for_user(user), :title => user.fullname, :class => "avatar #{size}"
        elsif user_or_area.present? && user_or_area.thumbnail.present?
          area = user_or_area
          avatar_html = link_to (image_tag(area.thumbnail) + (raw(content_tag :div, " ", :class => :ieframe))), area_path(area.id), :title => area.name, :class => "avatar #{size}"
        elsif user_or_area.present? && user_or_area.id.present? && user_or_area.fullname.present?
          user = user_or_area
          profile_image = Image.for(user)
          if profile_image.present?
            image_url = size == 'big' ? profile_image.image.url : profile_image.image.thumb.url
            avatar_html = link_to (image_tag(image_url) + (raw(content_tag :div, " ", :class => :ieframe))), path_for_user(user), :title => user.fullname, :class => "avatar #{size}"
          end
        end
      rescue
      end

      avatar_html
    end
  end

  def avatar_image(user_or_area, size = nil)
    avatar_html = image_tag "icons/faceless#{ "_#{size}" unless size.blank? }_avatar.png", :class => "avatar #{size}", :title => t('unknown_user')
    size = size.present?? size.to_s : ''

    if user_or_area.is_a?(Area)
      area = user_or_area
      if area.present? && area.image.present?
        avatar_html = (image_tag(area.thumbnail, :title => area.name, :class => "avatar #{size}" ) + (raw(content_tag :div, " ", :class => :ieframe)))
      end
    else
      begin
        if user_or_area.present? && user_or_area.profile_image.present?
          user = user_or_area
          image_url = size == 'big' ? user.profile_image_big : user.profile_image
          avatar_html = (image_tag(image_url, :title => user.fullname, :class => "avatar #{size}") + (raw(content_tag :div, " ", :class => :ieframe)))
        elsif user_or_area.present? && user_or_area.thumbnail.present?
          area = user_or_area
          avatar_html = (image_tag(area.thumbnail, :title => area.name, :class => "avatar #{size}") + (raw(content_tag :div, " ", :class => :ieframe)))
        elsif user_or_area.present? && user_or_area.id.present? && user_or_area.fullname.present?
          user = user_or_area
          profile_image = Image.for(user)
          if profile_image.present?
            image_url = size == 'big' ? profile_image.image.url : profile_image.image.thumb.url
            avatar_html = (image_tag(image_url, :title => user.fullname, :class => "avatar #{size}") + (raw(content_tag :div, " ", :class => :ieframe)))
          end
        end
      rescue
      end

      avatar_html
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
    content_tag :button, :type => :submit, :disabled => options[:disabled], :id => options[:id], :class => options[:class], :'data-url' => options[:'data-url'] do
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
    @notifications_list ||= user_signed_in?? current_user.notifications_grouped : []
  end

  def render_notification_item(notification, count, li_class = nil)

    case notification.item_type
    when 'Follow'
      content_tag :li, raw(t('.notifications.follow', :count => count, :name => link_to(notification.parent.fullname, user_path(notification.parent)))), :class => li_class
    when 'Question'
      content_tag :li, raw(t('.notifications.question', :count => count, :question => link_to(notification.item.class.model_name.human.downcase, question_path(notification.item)))), :class => li_class
    when 'Answer'
      content_tag :li, raw(t('.notifications.answer', :count => count, :question => link_to(t('.notifications.your_content.question'), question_path(notification.parent)))), :class => li_class
    when 'Comment'

      i18n_key, i18n_scope = if notification.parent && notification.parent.author == current_user
                               ['.notifications.comments_content_author', 'shared.nav_bar_buttons.notifications.your_content']
                             elsif notification.parent && notification.parent.tagged_politicians.include?(current_user)
                               ['.notifications.comments_tagged', 'shared.nav_bar_buttons.notifications.a_content']
                             else
                               ['.notifications.comments_content', 'shared.nav_bar_buttons.notifications.a_content']
                             end

      content_tag :li, raw(t(i18n_key, :count => count, :content => link_to(t(notification.parent.class.name.underscore, :scope => i18n_scope).downcase, send("#{notification.parent.class.name.underscore}_path", notification.parent)))), :class => li_class
    when 'Proposal'
      content_tag :li, raw(t('.notifications.proposal', :count => count, :proposal => link_to(notification.item.class.model_name.human.downcase, proposal_path(notification.item)))), :class => li_class
    when 'Argument'

      i18n_key, i18n_scope = if notification.parent && notification.parent.author == current_user
                               ['.notifications.argument_proposal_author', 'shared.nav_bar_buttons.notifications.your_content']
                             else
                               ['.notifications.argument_proposal', 'shared.nav_bar_buttons.notifications.a_content']
                             end

      content_tag :li, raw(t(i18n_key, :count => count, :content => link_to(t(notification.parent.class.name.underscore, :scope => i18n_scope).downcase, send("#{notification.parent.class.name.underscore}_path", notification.parent)))), :class => li_class
    when 'Vote'

      i18n_key, i18n_scope = if notification.parent && notification.parent.author == current_user
                               ['.notifications.vote_proposal_author', 'shared.nav_bar_buttons.notifications.your_content']
                             else
                               ['.notifications.vote_proposal', 'shared.nav_bar_buttons.notifications.a_content']
                             end

      content_tag :li, raw(t(i18n_key, :count => count, :content => link_to(t(notification.parent.class.name.underscore, :scope => i18n_scope).downcase, send("#{notification.parent.class.name.underscore}_path", notification.parent)))), :class => li_class
    when 'ContentUser'

      i18n_scope = 'shared.nav_bar_buttons.notifications.a_content'

      content_tag :li, raw(t('.notifications.content_users', :count => count, :content => link_to(t(notification.parent.class.name.underscore, :scope => i18n_scope).downcase, send("#{notification.parent.class.name.underscore}_path", notification.parent)))), :class => li_class
    end
  end

  def image_url(path)
    request.protocol + request.host_with_port + path
  end

  # def inline_sharing_partial_for_contents(content, content_type, url, message)
  #   render "shared/inline_content_sharing", :url => url, :content_id => content.id, :content => content, :content_type => content_type, :facebook_url    => url,
  #                            :twitter_message => message_for_twitter(content)
  # end

  # def inline_sharing_partial(content, content_type, url, message)
  #   render "shared/inline_sharing", :content_id => content.id, :content => content, :content_type => content_type, :facebook_url    => url,
  #                            :twitter_message => message_for_twitter(content)
  # end

  def message_for_twitter(content)
    if content and content.text
      twitter_message_link = polymorphic_url(content.parent || content)
      content.text.truncate(139 - twitter_message_link.length) + ' ' + twitter_message_link
    end
  end

  def message_for_facebook(content)
    twitter_message_link = polymorphic_url(content.parent || content)
    content.text.truncate(139 - twitter_message_link.length) + ' ' + twitter_message_link
  end

  def message_for_email(content)
    content.text
  end

  def render_list_element(item, item_type, options = {})
    default_class = ' clearfix'
    defaults = {
      :inline      => false,
      :path_suffix => ''
    }
    options = options.merge(defaults)
    options[:class] ||= ''
    options[:class] << default_class

    options[:class] << ' not_moderated' unless item.moderated

    relative_path = 'not_moderated/' unless item.moderated

    content_tag :li, :class => "#{options[:class]} #{item_type.underscore}" do
      render "shared/lists_elements/#{relative_path}#{item_type.underscore}#{options[:path_suffix]}", :data => item, :inline => options[:inline]
    end
  end

  def translate_field(model, field)
    model.send(:"#{field}_#{I18n.locale}") || (I18n.available_locales - [I18n.locale]).map{|lang| model.send(:"field_#{lang}")}.compact.first || ''
  end

end
