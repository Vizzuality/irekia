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

  def link_for_contents(filters = {})
    filters[:more_polemic] = params[:more_polemic] unless filters.key?(:more_polemic) || params[:more_polemic].blank?
    filters[:more_recent]  = params[:more_recent] unless filters.key?(:more_recent) || params[:more_recent].blank?
    filters[:more_recent]  = true unless filters.key?(:more_recent) || filters.key?(:more_polemic)
    filters[:type]         = params[:type] unless filters.key?(:type)

    search_path(filters)
  end
end
