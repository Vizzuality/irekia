module PoliticsHelper
  include ApplicationHelper

  def link_for_actions(politic)
    actions_politic_path(politic)
  end

  def link_for_proposals(politic)
    proposals_politic_path(politic)
  end

  def link_for_questions(politic)
    questions_politic_path(politic)
  end
end