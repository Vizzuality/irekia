class ContentsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index, :show]

  respond_to :html

  def index
    contents = params[:type].constantize.moderated

    if params[:query]
      case params[:type]
      when 'Question'
        contents = Question.search_existing_questions params[:query]
      end

    end

    @contents = contents.all

    respond_with(@contents, :layout => !request.xhr? )
  end

  def show
    content_class = params[:type].constantize
    @content = content_class.moderated.where(:id => params[:id]).first
    @comments = @content.comments
    @last_contents = content_class.moderated.order('published_at desc').where('id <> ?', @content.id).first(5)
    if current_user.present?
      @comment = @content.comments.build
      @comment.build_comment_data
      @comment.user = current_user
    end

    case @content
    when Question

      if @content.answer.blank?

        @new_request = @content.answer_requests.build

        if current_user.present? && current_user.has_not_requested_answer(@content)
          @new_request.user = current_user
        end

      else
        return if current_user && current_user.has_give_his_opinion(@content.answer)

        @answer_opinion = @content.answer.answer_opinions.build
        @answer_opinion.user = current_user if current_user.present?
        @answer_opinion.answer_opinion_data = AnswerOpinionData.new

        @answer_opinion_data_satisfactory = AnswerOpinionData.new(:satisfactory => true)
        @answer_opinion_data_not_satisfactory = AnswerOpinionData.new(:satisfactory => false)

      end

    when Proposal
      @new_in_favor = @content.arguments.in_favor.build
      @new_in_favor.argument_data = ArgumentData.new :in_favor => true
      @new_in_favor.user = current_user if current_user.present? && current_user.has_not_give_his_opinion(@content)

      @new_against = @content.arguments.against.build
      @new_against.argument_data = ArgumentData.new :in_favor => false
      @new_against.user = current_user if current_user.present? && current_user.has_not_give_his_opinion(@content)
    end
  end

  def update
    @content = params[:type].constantize.moderated.where(:id => params[:id]).first
    content_type = params[:type].downcase
    @content.update_attributes(params[content_type])
    redirect_to @content
  end
end
