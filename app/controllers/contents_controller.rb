class ContentsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index, :show]

  def index
    contents = params[:type].constantize.scoped

    if params[:query]
      case params[:type]
      when 'Question'
        contents = contents.joins(:question_data).where('question_text ilike ?', "%#{params[:query]}%")
      end

    end

    @contents = contents.all

    respond_to do |format|
      format.json {render :json => @contents.to_json}
      format.html
    end

  end

  def show
    @content = params[:type].constantize.where(:id => params[:id]).first
    if current_user.present?
      @comment = @content.comments.build
      @comment.build_comment_data
      @comment.user = current_user
    end
  end

  def update
    @content = params[:type].constantize.where(:id => params[:id]).first
    content_type = params[:type].downcase
    @content.update_attributes(params[content_type])
    redirect_to @content
  end
end