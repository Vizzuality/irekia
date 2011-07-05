module ApplicationHelper
  def render_action(action)

    case action.event_type
    when 'question'
      render_question Question.find(action.event_id)
    when 'answer'
      render_answer Answer.find(action.event_id)
    when 'proposal'
      render_proposal Proposal.find(action.event_id)
    when 'argument'
      render_argument Argument.find(action.event_id)
    when 'news'
      render_news News.find(action.event_id)
    end
  end

  def render_question(question)
    html = []

    content_tag :div, :class => :question do
      receiver = if question.receivers.present?
        question.receivers.map{|a| link_to(a.name, user_path(a))}.join(', ')
      else
        t('actions_stream.question.area')
      end

      html << content_tag(:p, :class => 'title') do
        raw t('actions_stream.question.title', :receiver => receiver)
      end

      html << content_tag(:p, %Q{"#{question.title}"}, :class => 'question')

      html << render_action_authors('question', question.authors, question.published_at)

      raw html.join
    end
  end

  def render_answer(answer)
    html = []

    content_tag :div, :class => :answer do
      html << content_tag(:p, :class => 'title') do
        raw t('actions_stream.answer.title', :question => content_tag(:span, answer.title))
      end

      html << content_tag(:p, %Q{"#{answer.body}"}, :class => 'answer')

      html << render_action_authors('answer', answer.authors, answer.published_at)

      raw html.join
    end
  end

  def render_proposal(proposal)
    html = []

    content_tag :div, :class => :proposal do
      html << content_tag(:p, proposal.title, :class => 'title')

      html << content_tag(:ul) do
        li = []
        li << content_tag(:li, t('actions_stream.proposal.in_favor', :count => proposal.arguments.in_favor.count))
        li << content_tag(:li, t('actions_stream.proposal.against', :count => proposal.arguments.against.count))
        raw li.join
      end

      html << render_action_authors('proposal', proposal.authors, proposal.published_at)

      raw html.join
    end
  end

  def render_argument(argument)
    html = []

    content_tag :div, :class => :argument do
      html << content_tag(:p, :class => 'title') do
        raw t("actions_stream.argument.title.#{argument.status.name}", :proposal => content_tag(:span, argument.proposal.title))
      end

      html << render_action_authors('argument', argument.authors, argument.published_at)

      raw html.join
    end
  end

  def render_news(news)
    html = []

    content_tag :div, :class => :news do
      html << content_tag(:p, news.title, :class => 'title')

      html << content_tag(:p, %Q{"#{news.body}"}, :class => 'news')

      html << render_action_authors('news', news.authors, news.published_at)

      raw html.join
    end
  end

  def render_action_authors(type, authors, updated_at)
    content_tag(:span, :class => 'author') do
      raw t("actions_stream.#{type}.author",
        :author => authors.map{|a| link_to(a.name, user_path(a))}.join(', '),
        :time => distance_of_time_in_words_to_now(updated_at)
      )
    end
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
end
