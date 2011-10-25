class Admin::ModerationController < Admin::AdminController

  def index
    @contents = {}
    @participations = {}

    @contents[:not_moderated] = Content.not_moderated.order('created_at ASC').page(params[:page])
    @participations[:not_moderated] = Participation.not_moderated.order('created_at ASC').page(params[:page])

    if params[:shows_moderated]
      @contents[:moderated] = Content.moderated.order('created_at ASC')
      @participations[:moderated] = Participation.moderated.order('created_at ASC')
    end

    session[:return_to] = admin_moderation_path
  end

  def validate_all
    item_type_to_validate = params[:type].singularize.capitalize.constantize

    item_type_to_validate.validate_all_not_moderated

    redirect_to admin_moderation_path
  end

end
