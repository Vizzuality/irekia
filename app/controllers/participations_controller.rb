class ParticipationsController < ApplicationController
  before_filter :get_participation_class
  before_filter :get_participation, :only => [:show, :update]

  respond_to :html

  def show
    @moderation_status = @participation.moderated?? 'moderated' : 'not_moderated'
    @content           = @participation.content

    @partial = params[:partial] || @participation_type

    respond_with(@participation) do |format|
      format.html { render :layout => !request.xhr? }
    end
  end

  def create
    participation_params = params[@participation_type]
    participation_params[:user_id] = current_user.id

    @participation = @participation_class.find_or_initialize participation_params

    if @participation.save
      redirect_to polymorphic_path(@participation, :partial => (params[:partial] || @participation_type))
    else
      head :error and return unless @participation.save
    end
  end

  def update
    if @participation.update_attributes params[@participation_type]
      redirect_to polymorphic_path(@participation, :partial => (params[:partial] || @participation_type))
    else
      head :error
    end
  end

  def get_participation_class
    @participation_class = params[:type].constantize
    @participation_type = params[:type].underscore
  end
  private :get_participation_class

  def get_participation
    @participation = @participation_class.where(:id => params[:id]).first
  end
  private :get_participation
end
