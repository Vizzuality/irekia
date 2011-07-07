module ApplicationHelper
  def render_action(action)

    case action.event_type
    when 'question'
      render_question Question.where(:id => action.event_id).first
    when 'answer'
      render_answer Answer.where(:id => action.event_id).first
    when 'proposal'
      render_proposal Proposal.where(:id => action.event_id).first
    when 'argument'
      render_argument Argument.where(:id => action.event_id).first
    when 'news'
      render_news News.where(:id => action.event_id).first
    end
  end

  def render_question(question)
    html = []

    content_tag :div, :class => :question do
      target_user = question.question_data.target_user
      receiver = if target_user.present?
        link_to target_user.name, user_path(target_user)
      else
        t('actions_stream.question.area')
      end

      html << content_tag(:p, :class => 'title') do
        raw t('actions_stream.question.title', :receiver => receiver)
      end

      html << content_tag(:p, %Q{"#{question.question_text}"}, :class => 'question')

      html << render_action_authors('question', question.users, question.published_at, question.comments)

      raw html.join
    end
  end

  def render_answer(answer)
    html = []

    content_tag :div, :class => :answer do
      html << content_tag(:p, :class => 'title') do
        raw t('actions_stream.answer.title', :question => content_tag(:span, answer.answer_data.question_text))
      end

      html << content_tag(:p, %Q{"#{answer.answer_text}"}, :class => 'answer')

      html << render_action_authors('answer', answer.users, answer.published_at, answer.comments)

      raw html.join
    end
  end

  def render_proposal(proposal)
    html = []

    content_tag :div, :class => :proposal do
      html << content_tag(:p, proposal.proposal_text, :class => 'title')

      html << content_tag(:ul) do
        li = []
        li << content_tag(:li, t('actions_stream.proposal.in_favor', :count => proposal.arguments.in_favor.count))
        li << content_tag(:li, t('actions_stream.proposal.against', :count => proposal.arguments.against.count))
        raw li.join
      end

      html << render_action_authors('proposal', proposal.users, proposal.published_at, proposal.comments)

      raw html.join
    end
  end

  def render_argument(argument)
    html = []

    content_tag :div, :class => :argument do
      html << content_tag(:p, :class => 'title') do
        raw t(argument.argument_data.in_favor ? 'in_favor' : 'against', :proposal => content_tag(:span, argument.proposal.proposal_text), :scope => 'actions_stream.argument.title')
      end

      html << render_action_authors('argument', [argument.user], argument.published_at, nil)

      raw html.join
    end
  end

  def render_news(news)
    html = []

    content_tag :div, :class => :news do
      html << content_tag(:p, news.title, :class => 'title')

      html << content_tag(:p, %Q{"#{news.body}"}, :class => 'news')

      html << render_action_authors('news', news.users, news.published_at, news.comments)

      raw html.join
    end
  end

  def render_action_authors(type, authors, updated_at, comments = [])
    html = []
    html << content_tag(:span, :class => 'author') do
      raw t("actions_stream.#{type}.author",
        :author => authors.map{|a| link_to(a.name, user_path(a))}.join(', '),
        :time => distance_of_time_in_words_to_now(updated_at)
      )
    end
    html << link_to(t('actions_stream.comments', :count => comments.count), '#') unless comments.nil?
    html << link_to(t('actions_stream.share'), '#')

    html.join('&nbsp;&middot;&nbsp;')
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
