module UsersHelper
  include ApplicationHelper

  def link_for_actions(params = {})
    actions_user_path(current_user, params)
  end

  def link_for_questions(params = {})
    questions_user_path(current_user, params)
  end

  def link_for_proposals(params = {})
    proposals_user_path(current_user, params)
  end

  def current_section?(section = nil)
    'selected' if params[:section] == section
  end

  def private_profile?
    current_user == @user
  end
end
