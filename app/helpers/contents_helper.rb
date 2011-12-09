module ContentsHelper
  include ApplicationHelper

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

  def sharing_partial(url, message)
    render "shared/sharing", :facebook_url    => url,
                             :twitter_message => message_for_twitter(url, message)
  end

  def can_i_answer_the_question?
    current_user && current_user.politician? && (@content.target_area.present? || current_user == @content.target_user)
  end
end
