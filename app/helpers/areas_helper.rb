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
      html << content_tag(:div, event.subject)
    end
    html.join
  end
end