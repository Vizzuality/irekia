module ApplicationHelper

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

  def avatar(user, size = nil)
    size = size.present?? size.to_s : ''

    if user.present? && user.profile_pictures.present?

      if user.politician?
        path = politician_path(user.id)
      else
        path = user_path(user.id)
      end

      link_to (image_tag(user.profile_image) + (raw (content_tag :div, " ", :class => :ieframe))), path, :title => user.fullname, :class => "avatar #{size}"
    else
      image_tag 'icons/faceless_avatar.png', :class => "avatar #{size}", :title => t('unknown_user')
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
    comment_date > 1.day.ago
  end

  def link_to_with_login(*args)
    html_options = args[2] || {}
    html_options[:class] = "floating-login #{html_options[:class]}" unless user_signed_in?
    html_options[:class].gsub!('after_', '') if user_signed_in?
    args[2] = html_options
    link_to(*args)
  end

  def class_for_modal_login
    'floating-login' unless user_signed_in?
  end
end

