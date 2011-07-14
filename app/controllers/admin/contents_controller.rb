class Admin::ContentsController < Admin::AdminController

  def update
    @content = Content.where(:id => params[:id]).first
    content_type = params[:type].downcase.to_sym

    if @content.update_attributes(params[content_type])
      redirect_back_or_default url_for [:admin, @content]
    else
      redirect_back_or_render_action :edit
    end

  end
end