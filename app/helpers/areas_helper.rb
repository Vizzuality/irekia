module AreasHelper
  include ApplicationHelper

  def link_for_actions
    actions_area_path(@area)
  end

  def link_for_proposals
    proposals_area_path(@area)
  end

  def link_for_questions
    questions_area_path(@area)
  end

  def link_for_agenda
    agenda_area_path(@area)
  end

  def agenda_for_day(agenda, day)
    day_events = agenda.select{|e| e.event_date.to_date.eql?(day.to_date)}
    html= []
    day_events.each do |event|
      html << content_tag(:div, event.subject, :class => 'title')

      if action_name == 'agenda'
        event_detail = []
        html << content_tag(:div, :class => 'detail') do
          event_detail << content_tag(:h4, l(event.event_date, :format => '%d, %B de %Y'))
          event_detail << content_tag(:h3, event.subject)
          event_detail << content_tag(:div, event.reverse_geocode, :class => 'location')
          event_detail << content_tag(:div, event.event_date.strftime('%H:%M'), :class => 'time')

          raw event_detail.join
        end
      end
    end
    html.join
  end

end