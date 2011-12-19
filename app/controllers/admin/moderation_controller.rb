class Admin::ModerationController < Admin::AdminController

  def index
    @items_count          = Moderation.not_moderated_count
    @moderation_time      = Moderation.get_moderation_time
    @items                = Moderation.items_not_moderated(params.slice(:oldest_first), params[:page] || 1)
    @show_moderation_info = true if request.xhr?

    session['user_return_to'] = admin_moderation_path
    render :partial => 'admin/moderation/items_list' and return if request.xhr?
  end

end
