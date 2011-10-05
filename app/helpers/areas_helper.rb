module AreasHelper
  include ApplicationHelper

  def link_for_actions(params = {})
    actions_area_path(@area, params)
  end

  def link_for_proposals(params = {})
    proposals_area_path(@area, params)
  end

  def link_for_questions(params = {})
    questions_area_path(@area, params)
  end

  def link_for_agenda(params = {})
    agenda_area_path(@area, params)
  end

end
