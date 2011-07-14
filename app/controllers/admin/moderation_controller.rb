class Admin::ModerationController < Admin::AdminController

  def index
    @contents = {}
    @participations = {}

    @contents[:not_moderated] = Content.not_moderated.order('created_at ASC')
    @participations[:not_moderated] = Participation.not_moderated.order('created_at ASC')

    if params[:shows_moderated]
      @contents[:moderated] = Content.moderated.order('created_at ASC')
      @participations[:moderated] = Participation.moderated.order('created_at ASC')
    end

    session[:return_to] = admin_moderation_path
  end

end