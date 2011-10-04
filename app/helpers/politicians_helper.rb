module PoliticiansHelper
  include ApplicationHelper

  def link_for_actions
    actions_politician_path(@politician)
  end

  def link_for_proposals
    proposals_politician_path(@politician)
  end

  def link_for_questions
    questions_politician_path(@politician)
  end

  def link_for_agenda
    agenda_politician_path(@politician)
  end

end
