class ContentsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index]

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
end