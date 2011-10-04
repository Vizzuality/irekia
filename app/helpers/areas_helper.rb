module AreasHelper
  include ApplicationHelper

  def link_for_actions
    actions_area_path(@area)
  end

  def link_for_proposals
    proposals_area_path(@area)
  end

  def link_for_questions
    questions_area_path(@area)
  end

  def link_for_agenda
    agenda_area_path(@area)
  end

end
