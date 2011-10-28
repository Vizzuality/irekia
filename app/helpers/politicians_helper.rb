module PoliticiansHelper
  include ApplicationHelper

  def link_for_actions(filters = {})
    filters[:more_polemic] = params[:more_polemic] unless filters.key?(:more_polemic)
    filters[:type]         = params[:type] unless filters.key?(:type)
    actions_politician_path(@politician, filters)
  end

  def link_for_proposals(filters = {})
    filters[:more_polemic]     = params[:more_polemic] unless filters.key?(:more_polemic)
    filters[:from_politicians] = params[:from_politicians] unless filters.key?(:from_politicians)
    filters[:from_citizens]    = params[:from_citizens] unless filters.key?(:from_citizens)

    proposals_politician_path(@politician, filters)
  end

  def link_for_questions(filters = {})
    filters[:more_polemic] = params[:more_polemic] unless filters.key?(:more_polemic)
    filters[:answered]     = params[:answered] unless filters.key?(:answered)

    questions_politician_path(@politician, filters)
  end

  def link_for_agenda(filters = {})
    agenda_politician_path(@politician, filters)
  end

end
