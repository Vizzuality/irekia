module ContentsHelper
  include ApplicationHelper

  def title
    @title = ['IREKIA']
    if @content.present?
      @title << @content.author.fullname if @content.author.present?
      @title << @content.class.model_name.human
      @title << @content.text
    end
    @title.join(' - ')
  end

  def render_partial_for_content
    case params[:type]
    when 'Question'
      @questions = @contents
      render 'shared/questions'
    end
  end

  def link_for_questions(filters = {})
    filters[:more_polemic] = params[:more_polemic] unless filters.key?(:more_polemic)
    filters[:answered]     = params[:answered] unless filters.key?(:answered)

    questions_path(filters)
  end

  def can_i_answer_the_question?
    current_user && current_user.politician? && (@content.target_area.present? || current_user == @content.target_user)
  end
end
