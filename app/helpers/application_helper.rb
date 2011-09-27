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

  def get_politic_title(user)
    translates_model_value(user.title, :name)[user.is_woman?? :female : :male] if user.title
  end

  def menu(options)
    render 'shared/menu', :options => options
  end

  def avatar(user, size = nil)
    render "shared/avatar", :user => user, :size => size
  end
end
