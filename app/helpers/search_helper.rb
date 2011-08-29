module SearchHelper
  def current_type?(type = nil)
    return 'selected' if type.blank? && params[:type].blank?
    'selected' if params[:type].eql?(type)
  end
end