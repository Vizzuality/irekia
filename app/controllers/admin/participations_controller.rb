class Admin::ParticipationsController < Admin::AdminController

  def update
    @participation = Participation.where(:id => params[:id]).first
    participation_type = params[:type].downcase.to_sym

    if @content.update_attributes(params[participation_type])
      redirect_back_or_default url_for [:admin, @participation]
    else
      redirect_back_or_render_action :edit
    end
  end

end