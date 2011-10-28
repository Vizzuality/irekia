class Admin::ContentsController < Admin::AdminController

  def update
    @content     = Content.where(:id => params[:id]).first
    content_type = params[:type].downcase.to_sym
    @content.moderated = params[content_type][:moderated]

    if @content.update_attributes(params[content_type])
      ModerationMailer.accepted(@content).deliver if params[content_type][:moderated] == 'true'
      redirect_back_or_default url_for [:admin, @content]
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
