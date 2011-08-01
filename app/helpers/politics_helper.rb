module PoliticsHelper
  include ApplicationHelper

  def link_for_actions
    actions_politic_path(@politic)
  end

  def link_for_proposals
    proposals_politic_path(@politic)
  end

  def link_for_questions
    questions_politic_path(@politic)
  end

  def link_for_agenda
    agenda_politic_path(@politic)
  end

  def agenda_for_day(agenda, day)
    day_events = agenda.select{|e| e.event_date.to_date.eql?(day.to_date)}
    html= []
    day_events.each do |event|
      html << content_tag(:div, event.subject)

      event_detail = []
      html << content_tag(:div, :class => 'detail') do
        event_detail << content_tag(:h4, event.event_date.strftime('%d,%B de %Y'))
        event_detail << content_tag(:h3, event.subject)
        event_detail << content_tag(:div, event.reverse_geocode, :class => 'location')
        event_detail << content_tag(:div, event.event_date.strftime('%H:%M'), :class => 'time')

        raw event_detail.join
      end
    end
    html.join
  end
end