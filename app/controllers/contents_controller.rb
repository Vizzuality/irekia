class ContentsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index, :show]
  before_filter :get_content_class

  respond_to :html, :json

  def index
    contents = params[:type].constantize.moderated

    if params[:query]
      case params[:type]
      when 'Question'
        @contents = Question.search_existing_questions params[:query]
        @questions = @contents
      when 'Proposal'
        @contents = Proposal.search_existing_proposals params[:query]
        @proposals = @contents
      end

    end

    @contents = contents.all

    respond_with(@contents) do |format|
      format.html do
        if request.xhr?
          locals = params[:mini] ? {:mini => true} : {}
          render :partial => "shared/#{@content_type.pluralize}_list",
                 :locals  => locals,
                 :layout  => false
        else
          render
        end
      end
      format.json
    end
  end

  def show
    @content = @content_class.where(:id => params[:id]).first
    @moderation_status = @content.moderated?? 'moderated' : 'not_moderated'

    @comments = @content.comments
    @last_contents = @content_class.moderated.order('published_at desc').where('id <> ?', @content.id).first(5)
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
        return if current_user && current_user.has_given_his_opinion?(@content.answer)

        @answer_opinion = @content.answer.answer_opinions.build
        @answer_opinion.user = current_user if current_user.present?
        @answer_opinion.answer_opinion_data = AnswerOpinionData.new

        @answer_opinion_data_satisfactory = AnswerOpinionData.new(:satisfactory => true)
        @answer_opinion_data_not_satisfactory = AnswerOpinionData.new(:satisfactory => false)

      end

    when Proposal
      @in_favor_count = @content.arguments.with_reason.in_favor.count
      @against_count = @content.arguments.with_reason.against.count

      @new_in_favor = @content.arguments.in_favor.build
      @new_in_favor.user = current_user if current_user.present?
      @new_in_favor.argument_data = @new_in_favor.build_argument_data

      @new_against = @content.arguments.against.build
      @new_against.user = current_user if current_user.present?
      @new_against.argument_data = @new_against.build_argument_data

      if current_user && current_user.has_given_his_opinion?(@content)
        @new_in_favor = current_user.his_opinion(@content).first
        @new_against = @new_in_favor
      end
    end

    respond_with(@content) do |format|
      format.html{ render :layout => !request.xhr?}
      format.json
    end
  end

  def create
    @content = @content_class.new params[@content_type]
    @content.users << current_user

    if @content.save
      redirect_to @content
    else
      head :error
    end
  end

  def update
    @content = @content_class.moderated.where(:id => params[:id]).first
    @content.update_attributes(params[@content_type])
    redirect_to @content
  end

  def get_content_class
    @content_class = params[:type].constantize
    @content_type = params[:type].downcase
  end
  private :get_content_class
end
