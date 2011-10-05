class Admin::ParticipationsController < Admin::AdminController

  def create
    participation_type = params[:type].downcase.to_sym
    @participation = Participation.new params[participation_type]

    if @participation.save
      head :sucess
    else
      head :error
    end
  end

  def update
    @participation     = Participation.where(:id => params[:id]).first
    participation_type = params[:type].downcase.to_sym

    if @participation.update_attributes(params[participation_type])
      ModerationMailer.accepted(@participation).deliver if params[participation_type][:moderated] == 'true'
      redirect_back_or_default url_for [:admin, @participation]
    else
      redirect_back_or_render_action :edit
    end
  end

  def destroy
    @participation     = Participation.where(:id => params[:id]).first
    participation_type = params[:type].downcase

    @participation.destroy

    redirect_back_or_default send("admin_#{participation_type.pluralize}_path")
  end
end
