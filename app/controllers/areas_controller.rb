class AreasController < ApplicationController

  skip_before_filter :authenticate_user!, :only => [:show, :actions, :questions, :proposals, :agenda, :team]
  before_filter :get_area_data,           :only => [:show, :actions, :questions, :proposals, :agenda, :team]
  before_filter :get_actions,             :only => [:show, :actions, :questions, :proposals, :agenda, :team]
  before_filter :get_questions,           :only => [:show, :questions]
  before_filter :get_proposals,           :only => [:show, :proposals]
  before_filter :get_agenda,              :only => [:show, :agenda]

  def show
  end

  def actions
  end

  def questions
    @show_questions_search = true
  end

  def proposals
  end

  def agenda
  end

  def team
  end

  private
  def get_area_data
    @area = Area.where(:id => params[:id]).first if params[:id].present?
    @team = @area.team.includes(:title)
  end

  def get_actions
    @actions = @area.actions
  end

  def get_questions
    @questions = @area.questions
  end

  def get_proposals
    @proposals = @area.proposals
  end

  def get_agenda
    case action_name
    when 'show'
      @beginning_of_calendar = Date.current.beginning_of_week
      @end_of_calendar       = Date.current.next_week.end_of_week
    when 'agenda'
      @beginning_of_calendar = Date.current.beginning_of_week
      @end_of_calendar       = Date.current.advance(:weeks => 3).end_of_week
    end

    @agenda = @area.events.where('event_data.event_date >= ? AND event_data.event_date <= ?', @beginning_of_calendar, @end_of_calendar)
    @days   = @beginning_of_calendar..@end_of_calendar
  end
end