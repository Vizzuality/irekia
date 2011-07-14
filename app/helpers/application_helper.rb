module ApplicationHelper
  def render_action(action, footer)

    case action.event_type
    when 'question'
      render_question Question.where(:id => action.event_id).first, footer, action.event_type
    when 'answer'
      render_answer Answer.where(:id => action.event_id).first, footer, action.event_type
    when 'proposal'
      render_proposal Proposal.where(:id => action.event_id).first, footer, action.event_type
    when 'argument'
      render_argument Argument.where(:id => action.event_id).first, footer, action.event_type
    when 'news'
      render_news News.where(:id => action.event_id).first, footer, action.event_type
    when 'event'
      render_event Event.where(:id => action.event_id).first, footer, action.event_type
    end
  end

  def render_question(question, footer, locale_scope = nil)
    html = []

    content_tag :div, :class => :question do
      target_user = question.question_data.target_user
      receiver = if target_user.present?
        link_to target_user.name, user_path(target_user)
      else
        t(".#{(['list_item'] + [locale_scope]).compact.join('.')}.area")
      end

      html << content_tag(:p, :class => 'title') do
        raw t(".#{(['list_item'] + [locale_scope]).compact.join('.')}.title", :receiver => receiver)
      end

      html << content_tag(:p, %Q{"#{question.question_text}"}, :class => 'question')

      html << footer

      raw html.join
    end
  end

  def render_answer(answer, footer, locale_scope = nil)
    html = []
    content_tag :div, :class => :answer do
      html << content_tag(:p, :class => 'title') do
        raw t(
          ".#{(['list_item'] + [locale_scope]).compact.join('.')}.title",
          :question => content_tag(:span, answer.answer_data.question_text)
        )
      end

      html << content_tag(:p, %Q{"#{answer.answer_text}"}, :class => 'answer')

      html << footer

      raw html.join
    end
  end

  def render_proposal(proposal, footer, locale_scope = nil)
    html = []

    content_tag :div, :class => :proposal do
      html << content_tag(:p, proposal.proposal_text, :class => 'title')

      html << content_tag(:ul) do
        li = []
        li << content_tag(:li, t(".#{(['list_item'] + [locale_scope]).compact.join('.')}.in_favor", :count => proposal.arguments.in_favor.count))
        li << content_tag(:li, t(".#{(['list_item'] + [locale_scope]).compact.join('.')}.against", :count => proposal.arguments.against.count))
        raw li.join
      end

      html << footer

      raw html.join
    end
  end

  def render_argument(argument, footer, locale_scope = nil)
    html = []

    content_tag :div, :class => :argument do
      html << content_tag(:p, :class => 'title') do
        raw t(".#{(['list_item'] + [locale_scope]).compact.join('.')}.title.#{argument.argument_data.in_favor ? 'in_favor' : 'against'}", :proposal => content_tag(:span, argument.proposal.proposal_text))
      end

      html << footer

      raw html.join
    end
  end

  def render_news(news, footer, locale_scope = nil)
    html = []

    content_tag :div, :class => :news do
      html << content_tag(:p, news.title, :class => 'title')

      html << content_tag(:p, %Q{"#{news.body}"}, :class => 'news')

      html << footer

      raw html.join
    end
  end

  def render_event(event, footer, locale_scope = nil)
    html = []

    content_tag :div, :class => :event do
      html << content_tag(:p, event.subject, :class => 'subject')

      raw html.join
    end
  end

  def render_comment(comment, footer, locale_scope = nil)
    html = []

    content_tag :div, :class => :comment do
      html << content_tag(:p, comment.body)
      html << footer

      raw html.join
    end
  end

  def footer_for_action(action)
    case action.event_type
    when 'question'
      content  = Question.where(:id => action.event_id).first
      comments = content.comments
      user     = content.users.present?? content.users.first : nil
    when 'answer'
      content  = Answer.where(:id => action.event_id).first
      comments = content.comments
      user     = content.users.present?? content.users.first : nil
    when 'proposal'
      content  = Proposal.where(:id => action.event_id).first
      comments = content.comments
      user     = content.users.present?? content.users.first : nil
    when 'argument'
      content  = Argument.where(:id => action.event_id).first
      comments = []
      user     = content.user
    when 'news'
      content  = News.where(:id => action.event_id).first
      comments = content.comments
      user     = content.users.present?? content.users.first : nil
    when 'event'
      content  = Event.where(:id => action.event_id).first
      comments = content.comments
      user     = content.users.present?? content.users.first : nil
    end

    html = []
    html << content_author(user, content.published_at, action.event_type)
    html << link_to(t('.list_item.comments', :count => comments.count), '#') unless comments.nil?
    html << link_to(t('.list_item.share'), '#')

    html.join('&nbsp;&middot;&nbsp;')
  end

  def footer_for_question(question)
    html = []
    html << content_author(question.users.first, question.published_at)
    if question.answer.present?
      html << link_to(t('.list_item.answered', :time => distance_of_time_in_words_to_now(question.answer.updated_at)), '#')
    else
      html << link_to(t('.list_item.not_answered'), '#', :class => :not_answered)
    end
    html << link_to(t('actions_stream.comments', :count => question.comments.count), '#') unless question.comments.nil?

    html.join('&nbsp;&middot;&nbsp;')
  end

  def footer_for_answer(answer)

  end

  def footer_for_proposal(proposal)
    html = []
    html << content_author(proposal.users.first, proposal.published_at)
    if proposal.arguments.present?
      html << link_to(t('.list_item.participation', :count => proposal.arguments.count), '#')
    end

    html.join('&nbsp;&middot;&nbsp;')
  end

  def footer_for_argument(argument)

  end

  def footer_for_news(news)

  end

  def footer_for_event(event)
  end

  def content_author(author, updated_at, locale_scope = nil)
    html = []
    html << image_tag(author.profile_image_thumb_url) if author.profile_pictures.present?
    html << content_tag(:span, :class => 'author') do
      raw t(".#{(['list_item'] + [locale_scope]).compact.join('.')}.author",
        :author => link_to(author.name, user_path(author)),
        :time => distance_of_time_in_words_to_now(updated_at)
      )
    end
    raw html.join
  end

  def current_area?(area)
    area.eql?(@area) ? 'selected' : nil
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def current_action?(action)
    'selected' if action_name.eql?(action.to_s)
  end

  def translates_model_value(model, key)
    t([model.class.name.downcase, key, model["#{key}_i18n_key"]].join('.'), :scope => 'activerecord.values')
  end
end
