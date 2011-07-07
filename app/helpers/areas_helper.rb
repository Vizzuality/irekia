module AreasHelper
  include ApplicationHelper

  def link_for_actions(area)
    actions_area_path(area)
  end

  def link_for_proposals(area)
    proposals_area_path(area)
  end

  def link_for_questions(area)
    questions_area_path(area)
  end
end