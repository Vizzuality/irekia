class ContentsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index, :show]

  def index
    contents = params[:type].constantize.moderated

    if params[:query]
      case params[:type]
      when 'Question'
        contents = contents.joins(:question_data).where('question_text ilike ?', "%#{params[:query]}%")
      end

    end

    @contents = contents.all

    respond_to do |format|
      format.json {render :json => @contents.to_json}
      format.html
    end

  end

  def show
    content_class = params[:type].constantize
    @content = content_class.moderated.where(:id => params[:id]).first
    @last_contents = content_class.moderated.order('published_at desc').where('id <> ?', @content.id).first(5)
    if current_user.present?
      @comment = @content.comments.build
      @comment.build_comment_data
      @comment.user = current_user
    end

    case @content
    when Question

      if @content.answer.blank?

        if current_user.present? && current_user.has_not_requested_answer(@content)
          @new_request = @content.answer_requests.build
          @new_request.user = current_user
        end

      else
        if current_user.present? && current_user.has_not_give_his_opinion(@content.answer)
          @answer_opinion = @content.answer.answer_opinions.build
          @answer_opinion.user = current_user
          @answer_opinion.answer_opinion_data = AnswerOpinionData.new

          @answer_opinion_data_satisfactory = AnswerOpinionData.new(:satisfactory => true)
          @answer_opinion_data_not_satisfactory = AnswerOpinionData.new(:satisfactory => false)
        end
      end

    end
  end

  def update
    @content = params[:type].constantize.moderated.where(:id => params[:id]).first
    content_type = params[:type].downcase
    @content.update_attributes(params[content_type])
    redirect_to @content
  end
end