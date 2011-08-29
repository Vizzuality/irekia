module SearchHelper
  def current_type?(type = nil)
    return 'selected' if type.blank? && params[:search][:type].blank?
    'selected' if params[:search][:type].eql?(type)
  end

  def show_contents?
    params[:search][:type].blank? || params[:search][:type] == 'contents'
  end

  def show_politics?
    params[:search][:type].blank? || params[:search][:type] == 'politics'
  end

  def show_users?
    params[:search][:type].blank? || params[:search][:type] == 'users'
  end

  def how_many_contents_to_show?
    params[:search][:type].blank?? 5 : 10
  end

  def how_many_users_to_show?
    params[:search][:type].blank?? 9 : 20
  end
end