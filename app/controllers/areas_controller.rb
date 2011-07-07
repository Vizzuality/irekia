class AreasController < ApplicationController

  skip_before_filter :authenticate_user!, :only => [:show, :actions, :questions, :proposals, :agenda, :team]
  before_filter :get_area_data, :only => [:show, :actions, :questions, :proposals, :agenda, :team]
  before_filter :get_actions, :only => [:show, :actions, :questions, :proposals, :agenda, :team]
  before_filter :get_questions, :only => [:show, :questions]
  before_filter :get_proposals, :only => [:show, :proposals]

  def show
  end

  def actions
  end

  def questions
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
end