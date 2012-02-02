class HomeController < ApplicationController
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper
  include ApplicationHelper

  skip_before_filter :authenticate_user!, :only => [:index, :agenda, :change_locale, :byebye]

  respond_to :html, :json, :ics, :rss, :iphone

  def index
    get_areas
    get_actions
    get_site_counters

    render :partial => 'shared/actions_list' and return if request.xhr?
  end

  def nav_bar_buttons
    render :partial => 'shared/nav_bar_buttons', :layout => false
  end

  def agenda
    @previous_month_counter = -1
    @next_month_counter     = 1
    @previous_month_counter -= params[:next_month].to_i
    @next_month_counter     += params[:next_month].to_i

    @current_date   = Date.current.advance(:months  => params[:next_month].to_i)
    @next_month     = @current_date.advance(:months => 1)
    @previous_month = @current_date.advance(:months => -1)

    @agenda, @days, @agenda_json = Event.general_agenda(params.slice(:next_month))

    render :partial => 'shared/agenda_list',
           :layout  => nil and return if request.xhr?

    respond_with @agenda do |format|
      format.html
      format.ics do
        render :text => Event.to_calendar(@agenda)
      end
    end
  end

  def change_locale
    if params[:new_locale]
      I18n.locale = params[:new_locale]
      cookies[:current_locale] = {:value => I18n.locale, :expires => 1.year.from_now}
      current_user.update_attribute 'locale', I18n.locale if user_signed_in?
      session['user_return_to'] = nil
    end

    redirect_to root_path
  end

  def byebye

  end

  def get_areas
    super
    @areas                 = Area.areas_for_homepage
  end
  private :get_areas

  def get_actions
    @actions               = AreaPublicStream.for_homepage
    @news_count            = @actions.news.count            || 0
    @questions_count       = @actions.questions.count       || 0
    @answers_count         = @actions.answers.count         || 0
    @proposals_count       = @actions.proposals.count       || 0
    @arguments_count       = @actions.arguments.count       || 0
    @votes_count           = @actions.votes.count           || 0
    @photos_count          = @actions.photos.count          || 0
    @videos_count          = @actions.videos.count          || 0
    @status_messages_count = @actions.status_messages.count || 0
    @tweets_count          = @actions.tweets.count          || 0

    @actions = @actions.where(:event_type => [params[:type]].flatten.map(&:camelize)) if params[:type]
    @actions = @actions.page(1).per(20).sort{|a, b| b.published_at <=> a.published_at}
    @rss_actions = @actions.map{|a| OpenStruct.new(:type => a.event_type.underscore, :id => a.event_id, :text => text_for_rss_title(a), :body => text_for_rss_body(a), :published_at => a.published_at)} if request.format.rss?
  end
  private :get_actions

  def get_site_counters
    @all_citizens           = User.citizens.count
    @all_politicians        = User.politicians.count
    @all_questions          = Question.moderated.count
    @all_questions_answered = Question.moderated.answered.count
    @all_proposals          = Proposal.moderated.count
    @all_votes              = Vote.count
  end
  private :get_site_counters

  def text_for_rss_title(action)
    case action.event_type
      when 'News'
        translate_field(action.item.area, 'name') if action.item.area.present?
      when 'StatusMessage'
        action.item.author.fullname
      when 'Tweet'
        action.item.author.fullname
      when 'Vote'
        action.item.author.fullname
      when 'Photo'
        action.item.author.fullname
      when 'Comment'
        action.item.content.text
      when 'Answer'
        action.item.question_text
      when 'Argument'
        action.item.title
    end
  end
  private :text_for_rss_title

  def text_for_rss_body(action)
    case action.event_type
      when 'News'
        news = action.item
        <<-HTML
          <p>#{translate_field(news, 'title')}</p>
          #{simple_format translate_field(news, 'body')}
        HTML
      when 'StatusMessage'
        action.item.message
      when 'Tweet'
        action.item.message
      when 'Photo'
        photo = action.item
        <<-HTML
          <p>#{photo.title}</p>
          <img src="#{photo.content_url}" alt="#{photo.title}"/>
        HTML
      when 'Event'
        event = action.item
        <<-HTML
          <p>#{translate_field(event, 'title')}</p>
          #{simple_format translate_field(event, 'body')}
        HTML
      when 'Comment'
        action.item.body
      when 'Proposal'
        proposal = action.item
        <<-HTML
          <p>#{translate_field(proposal, 'title')}</p>
        HTML
      when 'Answer'
        action.item.answer_text
      when 'Question'
        question = action.item
        target = if question.target_user.present?
          t('home.index.rss.items.body.question_for_politician', :name => question.target_user.fullname)
        else
          t('home.index.rss.items.body.question_for_area', :name => question.target_area.send("name_#{I18n.locale}"))
        end
        <<-HTML
          <p>#{target}</p>
          #{simple_format action.item.question_text}
        HTML
    end
  end
  private :text_for_rss_body
end
