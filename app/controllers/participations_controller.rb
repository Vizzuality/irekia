class ParticipationsController < ApplicationController
  before_filter :get_participation_class

  respond_to :html

  def show
    @participation = @participation_class.where(:id => params[:id]).first
    @moderation_status = @participation.moderated?? 'moderated' : 'not_moderated'

    respond_with(@participation) do |format|
      format.html { render :layout => !request.xhr? }
    end


  end

  def create
    @participation = @participation_class.new params[@participation_type]

    @participation.author = current_user
    if @participation.save
      redirect_to @participation
    else
      head :error
    end
  end

  def get_participation_class
    @participation_class = params[:type].constantize
    @participation_type = params[:type].downcase
  end
  private :get_participation_class
end
