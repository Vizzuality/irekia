module ContentsHelper
  include ApplicationHelper

  def render_partial_for_content
    case params[:type]
    when 'Question'
      @questions = @contents
      render 'shared/questions'
    end
  end

  def link_for_questions
    questions_path
  end
end