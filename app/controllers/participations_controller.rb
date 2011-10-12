class ParticipationsController < ApplicationController

  respond_to :html

  def show
    @participation = Participation.where(:id => params[:id]).first

    respond_with(@participation) do |format|
      format.html { render :layout => !request.xhr? }
    end

  end

  def create
    participation_class = params[:type].constantize
    participation_type = params[:type].downcase.to_sym
    @participation = participation_class.new params[participation_type]

    if @participation.save
      redirect_to @participation
    else
      head :error
    end
  end

end
