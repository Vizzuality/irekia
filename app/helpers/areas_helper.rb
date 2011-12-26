module AreasHelper
  include ApplicationHelper

  def title
    @title = ['IREKIA']
    @title << @area.name
    @title << t(params[:action], :scope => 'areas.navigation_menu.menu') if params[:action]
    @title.join(' - ')
  end

  def link_for_actions(filters = {})
    filters[:more_polemic] = params[:more_polemic] unless filters.key?(:more_polemic)
    filters[:type]         = params[:type] unless filters.key?(:type)

    actions_area_path(@area, filters)
  end

  def link_for_proposals(filters = {})
    filters[:more_polemic]     = params[:more_polemic] unless filters.key?(:more_polemic)
    filters[:from_politicians] = params[:from_politicians] unless filters.key?(:from_politicians)
    filters[:from_citizens]    = params[:from_citizens] unless filters.key?(:from_citizens)

    proposals_area_path(@area, filters)
  end

  def link_for_questions(filters = {})
    filters[:more_polemic] = params[:more_polemic] unless filters.key?(:more_polemic)
    filters[:answered]     = params[:answered] unless filters.key?(:answered)

    questions_area_path(@area, filters)
  end

  def link_for_agenda(filters = {})
    agenda_area_path(@area, filters)
  end

end
