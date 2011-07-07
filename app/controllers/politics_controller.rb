class PoliticsController < UsersController
  before_filter :get_user,                   :only => [:show, :actions, :questions, :proposals, :agenda]
  before_filter :get_politic,                :only => [:show, :actions, :questions, :proposals, :agenda]
  before_filter :build_questions_for_update, :only => [:show]
  before_filter :get_actions,                :only => [:show, :actions]
  before_filter :get_questions,              :only => [:show, :questions]
  before_filter :get_proposals,              :only => [:show, :proposals]

  def show
    super
    session[:return_to] = politic_path(@politic)
  end

  def actions
  end

  def questions
  end

  def proposals
  end

  def agenda
  end

  private
  def get_politic
    @politic = @user
  end

  def build_questions_for_update
    return if current_user.blank?
    @question                  = current_user.questions.build
    @question_data             = @question.build_question_data
    @question_data.target_user = @user
  end

  def get_actions
    @actions = @politic.actions
  end

  def get_questions
    @questions = @politic.questions_received
  end

  def get_proposals
    @proposals = @politic.proposals_received
  end

end