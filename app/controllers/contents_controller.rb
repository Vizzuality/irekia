class ContentsController < ApplicationController
  def index
    @contents = params[:type].constantize.all
  end
end