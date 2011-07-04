module ApplicationHelper
  def render_action(action)
    html = []

    content_tag :div, :class => action.event_type do

      case action.event_type
      when 'question'
        question = Question.find(action.event_id)
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
      when 'answer'
        answer = Answer.find(action.event_id)
        html << content_tag(:p, :class => 'title') do
          raw t('actions_stream.answer.title', :question => content_tag(:span, answer.title))
        end

        html << content_tag(:p, %Q{"#{answer.body}"}, :class => 'answer')

        html << render_action_authors('answer', answer.authors, answer.published_at)

        raw html.join
      when 'proposal'

        raw html.join
      when 'argument'
        argument = Argument.find(action.event_id)
        html << content_tag(:p, :class => 'title') do
          raw t("actions_stream.argument.title.#{argument.status.name}", :proposal => content_tag(:span, argument.proposal.title))
        end

        html << render_action_authors('argument', argument.authors, argument.published_at)

        raw html.join
      when 'news'
        news = News.find(action.event_id)
        html << content_tag(:p, news.title, :class => 'title')

        html << content_tag(:p, %Q{"#{news.body}"}, :class => 'news')

        html << render_action_authors('news', news.authors, news.published_at)

        raw html.join
      end

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
end
