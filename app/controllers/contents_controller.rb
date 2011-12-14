class ContentsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index, :show]
  before_filter :get_content_class
  before_filter :get_content, :only => [:show, :edit]
  before_filter :check_edition_permission, :only => [:edit]
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

  def edit
    @editable = true
    @content = @content_class.by_id(params[:id])

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
        @answer = @content.answer
      end
    when Proposal
      #votes
      @vote_in_favor               = @content.votes.in_favor.build
      @vote_in_favor.user          = current_user if current_user.present?
      @vote_in_favor.vote_data     = @vote_in_favor.build_vote_data

      @vote_against                = @content.votes.against.build
      @vote_against.user           = current_user if current_user.present?
      @vote_against.vote_data      = @vote_against.build_vote_data

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

  def show
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
        @answer = @content.answer
      end

    when Proposal
      #votes
      @vote_in_favor               = @content.votes.in_favor.build
      @vote_in_favor.user          = current_user if current_user.present?
      @vote_in_favor.vote_data     = @vote_in_favor.build_vote_data

      @vote_against                = @content.votes.against.build
      @vote_against.user           = current_user if current_user.present?
      @vote_against.vote_data      = @vote_against.build_vote_data

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
    render :text => @image.to_json and return if @image.present?

    @content        = @content_class.new params[@content_type]
    @content.author = current_user

    @author_role = 'politician' if current_user.politician?
    @partial     = params[:partial] || @content_type

    head :error and return unless @content.save
    share_content
    render :layout => !request.xhr?
  end

  def update
    render :json => @image and return if @image.present?

    @content        = @content_class.moderated.where(:id => params[:id]).first
    @content_params = params[@content_type]
    @content.update_attributes(@content_params)

    @author_role = 'politician'    if current_user.politician?
    @author_role = 'administrator' if current_user.administrator?
    @partial     = params[:partial] || @content_type

    head :error and return unless @content.save
    share_content
    render :partial => "contents/edit/#{@partial}"
  end

  def get_content_class
    @content_class = params[:type].constantize
    @content_type = params[:type].underscore
  end
  private :get_content_class

  def get_content
    @content = @content_class.by_id(params[:id])
  end
  private :get_content

  def check_edition_permission
    redirect_to @content unless current_user && current_user.administrator?
  end
  private :check_edition_permission

  def process_file_upload
    return unless params[:qqfile].present?

    uploader = ImageUploader.cache_from_io!(request.body, params.delete(:qqfile))
    @image = {
      :success => true,
      :image_cache_name => uploader.cache_name
    }
  end
  private :process_file_upload

  def share_content
    if params[:share_in_facebook] == '1'
      begin
        MiniFB.post(current_user.facebook_oauth_token, 'me', :type => 'feed', :message => "#{@content.facebook_share_message} #{url_for(@content)}")
      rescue => e
        Rails.logger.error e
      end
    end

    if params[:share_in_twitter] == '1'
      begin
        Twitter.configure do |config|
          config.oauth_token        = current_user.twitter_oauth_token
          config.oauth_token_secret = current_user.twitter_oauth_token_secret
        end
        twitter_message_link = url_for(@content.parent || @content)
        twitter_message = @content.twitter_share_message.truncate(139 - twitter_message_link.length) + ' ' + twitter_message_link
        Twitter.update(twitter_message)
      rescue => e
        Rails.logger.error e
      end
    end
  end
  private :share_content
end

