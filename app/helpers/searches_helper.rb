module SearchesHelper
  def current_type?(type = nil)
    return 'selected' if type.blank? && params[:search][:type].blank?
    'selected' if params[:search][:type].eql?(type)
  end

  def has_politicians?
    @politicians.size > 0
  end

  def has_areas?
    @areas.size > 0
  end

  def has_citizens?
    @citizens.size > 0
  end

  def has_contents?
    @contents.size > 0
  end

  def search_params
    params.except(:action)
  end
end
