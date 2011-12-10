module UsersHelper
  include ApplicationHelper

  def link_for_actions(filters = {})
    filters[:more_polemic] = params[:more_polemic] unless filters[:more_polemic].present?
    filters[:type]         = params[:type] unless filters[:type].present?

    actions_user_path(@user, filters)
  end

  def link_for_proposals(filters = {})
    filters[:more_polemic]     = params[:more_polemic] unless filters.key?(:more_polemic)
    filters[:from_politicians] = params[:from_politicians] unless filters.key?(:from_politicians)
    filters[:from_citizens]    = params[:from_citizens] unless filters.key?(:from_citizens)

    proposals_user_path(@user, filters)
  end

  def link_for_questions(filters = {})
    filters[:more_polemic] = params[:more_polemic] unless filters.key?(:more_polemic)
    filters[:answered]     = params[:answered] unless filters.key?(:answered)

    questions_user_path(@user, filters)
  end

  def link_for_agenda(filters = {})
    agenda_user_path(@user, filters)
  end

  def current_section?(section = nil)
    'selected' if params[:section] == section
  end

end
