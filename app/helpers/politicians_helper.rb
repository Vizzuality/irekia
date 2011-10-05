module PoliticiansHelper
  include ApplicationHelper

  def link_for_actions(params = {})
    actions_politician_path(@politician, params)
  end

  def link_for_proposals(params = {})
    proposals_politician_path(@politician, params)
  end

  def link_for_questions(params = {})
    questions_politician_path(@politician, params)
  end

  def link_for_agenda(params = {})
    agenda_politician_path(@politician, params)
  end

end
