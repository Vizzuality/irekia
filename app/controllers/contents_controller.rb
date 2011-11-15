class ContentsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index, :show]
  before_filter :get_content_class
  before_filter :process_file_upload, :only => [:create, :update]

  respond_to :html, :json

  def index
    contents = params[:type].constantize.moderated

    if params[:query]
      case params[:type]
      when 'Question'
        @contents = Question.search_existing_questions(params[:query]).page(1).per(params[:per_page] || 3)
        @questions = @contents
      when 'Proposal'
        @contents = Proposal.search_existing_proposals(params[:query]).page(1).per(params[:per_page] || 3)

        @proposals = @contents
      end
    else
      @contents = contents.all
    end

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
    @content = @content_class.by_id(params[:id])
    @moderation_status = @content.moderated?? 'moderated' : 'not_moderated'

    @comments = @content.comments.moderated.all
    @comments_count = @content.comments_count
    @last_contents = @content.last_contents(3)

    @comment = @content.comments.build
    @comment.build_comment_data

    @tags = @content.tags.present?? @content.tags.split(',') : []

    case @content
    when Question

      if @content.answer.blank?
        @user_has_requested_answer = current_user && current_user.has_requested_answer(params[:id])

        if current_user.present? && current_user.politician?
          @new_answer = @content.build_answer
          @new_answer.answer_data = @new_answer.build_answer_data
        elsif current_user.blank? || current_user.has_not_requested_answer(params[:id])
          @new_request = @content.answer_requests.build

        end
      else
        return if current_user && current_user.has_given_his_opinion?(@content.answer)

        @answer = @content.answer
        @satisfactory_opinions_count = @content.answer.answer_opinions.satisfactory.count
        @not_satisfactory_opinions_count = @content.answer.answer_opinions.not_satisfactory.count
        @answer_opinion = @content.answer.answer_opinions.build
        @answer_opinion.user = current_user if current_user.present?
        @answer_opinion.answer_opinion_data = AnswerOpinionData.new

        @answer_opinion_data_satisfactory = AnswerOpinionData.new(:satisfactory => true)
        @answer_opinion_data_not_satisfactory = AnswerOpinionData.new(:satisfactory => false)

      end

    when Proposal

      #votes
      @vote_in_favor               = @content.votes.in_favor.build
      @vote_in_favor.user          = current_user if current_user.present?
      @vote_in_favor.vote_data     = @vote_in_favor.build_vote_data

      @vote_against               = @content.votes.against.build
      @vote_against.user          = current_user if current_user.present?
      @vote_against.vote_data     = @vote_against.build_vote_data

      if current_user && current_user.has_given_his_opinion?(@content)
        @vote = current_user.his_opinion(@content).first
      elsif current_user
        @vote = @content.votes.where('user_id = ?', current_user.id).build
        @vote.vote_data = VoteData.new
      else
        @vote = @content.votes.build
        @vote.vote_data = @vote.build_vote_data
      end

      #arguments
      @arguments_in_favor = @content.arguments.moderated.in_favor.all
      @arguments_against  = @content.arguments.moderated.against.all

      @argument_in_favor               = @content.arguments.in_favor.build
      @argument_in_favor.user          = current_user if current_user.present?
      @argument_in_favor.argument_data = @argument_in_favor.build_argument_data

      @argument_against               = @content.arguments.against.build
      @argument_against.user          = current_user if current_user.present?
      @argument_against.argument_data = @argument_against.build_argument_data
    end

    respond_with(@content) do |format|
      format.html{ render :layout => !request.xhr?}
      format.json
    end
  end

  def create
    render :json => @image and return if @image.present?

    @content = @content_class.new params[@content_type]
    @content.author = current_user

    if @content.save
      redirect_to @content
    else
      head :error
    end
  end

  def update
    render :json => @image and return if @image.present?

    @content = @content_class.moderated.where(:id => params[:id]).first
    @content.update_attributes(params[@content_type])
    redirect_to @content
  end

  def get_content_class
    @content_class = params[:type].constantize
    @content_type = params[:type].underscore
  end
  private :get_content_class

  def process_file_upload
    return unless params[:qqfile].present?

    uploader = ImageUploader.cache_from_io!(request.body, params.delete(:qqfile))
    @image = {
      :success => true,
      :image_cache_name => uploader.cache_name
    }
  end
  private :process_file_upload
end

