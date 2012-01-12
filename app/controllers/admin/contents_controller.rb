class Admin::ContentsController < Admin::AdminController

  def update
    @content           = Content.find(params[:id])
    content_type       = params[:type].downcase.to_sym
    @content.moderated = params[content_type][:moderated]
    @content.rejected  = params[content_type][:rejected]

    if @content.update_attributes(params[content_type])
      ModerationMailer.accepted(@content).deliver if params[content_type][:moderated] == 'true'
      ModerationMailer.rejected(@content).deliver if params[content_type][:rejected] == 'true'

      @items_count          = Moderation.not_moderated_count
      @moderation_time      = Moderation.get_moderation_time

      render :partial => 'admin/moderation/moderation_info'
    else
      redirect_back_or_render_action :edit
    end

  end

  def destroy
    @content     = Content.where(:id => params[:id]).first
    content_type = params[:type].downcase

    @content.destroy

    redirect_back_or_default send("admin_#{content_type.pluralize}_path")
  end
end
