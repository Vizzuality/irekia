module SearchHelper
  def current_type?(type = nil)
    return 'selected' if type.blank? && params[:type].blank?
    'selected' if params[:type].eql?(type)
  end

  def show_contents?
    params[:type].blank? || params[:type] == 'contents'
  end

  def show_politics?
    params[:type].blank? || params[:type] == 'politics'
  end

  def show_users?
    params[:type].blank? || params[:type] == 'users'
  end

  def how_many_contents_to_show?
    params[:type].blank?? 5 : 10
  end
end