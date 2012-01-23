class Admin::ContentsController < Admin::AdminController

  def update
    @content           = Content.find(params[:id])
    content_type       = params[:type].downcase.to_sym
    @content.moderated = params[content_type][:moderated]
    @content.rejected  = params[content_type][:rejected] || params[content_type][:moderated].blank?

    if @content.update_attributes(params[content_type])
      IrekiaMailer.moderation_approved(@content).deliver if @content.moderated
      IrekiaMailer.moderation_rejected(@content).deliver if @content.rejected

      @items_count          = Moderation.not_moderated_count
      @moderation_time      = Moderation.get_moderation_time

      render :partial => 'admin/moderation/moderation_info'
    else
      redirect_back_or_render_action :edit
    end

  end

  def destroy
    @content     = Content.find(params[:id])
    content_type = params[:type].downcase

    @content.destroy

    redirect_back_or_default send("admin_#{content_type.pluralize}_path")
  end
end
