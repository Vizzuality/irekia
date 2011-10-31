class SearchesController < ApplicationController
  skip_before_filter :authenticate_user!
  before_filter :get_common_data
  before_filter :get_contents, :only => [:show, :contents]
  before_filter :paginate, :only => [:show, :contents]

  def show
    @contents = @contents.limit(10)
    if request.xhr? && (params.key?('more_polemic') || params.key?('more_recent') || params.key?('type'))
      render :partial => 'contents_list' and return
    end

    contents_areas    = @contents.inject([]){|arr, content| arr + [content.area]} || []
    citizens_areas    = @citizens.inject([]){|arr, citizen| arr + citizen.areas} || []
    politicians_areas = @politicians.inject([]){|arr, politician| arr + politician.areas} || []
    @areas = (@areas + contents_areas + citizens_areas + politicians_areas).uniq

    if request.xhr?
      head(:not_found) and return if @areas.blank? && @contents.blank? && @citizens.blank? && @politicians.blank?
      render :autocomplete, :layout => false and return
    end
  end

  def contents

  end

  def politicians

  end

  def citizens

  end

  def get_common_data
    @search = OpenStruct.new(params[:search])

    @areas    = Area.search_by_name_and_description @search.query
    @contents = AreaPublicStream.only_contents.search @search.query

    users     = User.search_by_name_description_province_and_city @search.query
    @citizens = users.citizens
    @politicians = users.politicians

    @contents_count = @contents.count
    @politicians_count = @politicians.count
    @citizens_count = @citizens.count
  end
  private :get_common_data

  def get_contents
    @contents = @contents.where(:event_type => params[:type]) if params[:type].present?

    @contents = if params[:more_polemic]
      @contents.more_polemic
    else
      @contents.more_recent
    end
  end
  private :get_contents

  def paginate
    if action_name == 'show' || params[:referer] == 'show'
      @contents   = @contents.page(1).per(4)   if @contents
    else
      @contents   = @contents.page(params[:page]).per(10)   if @contents
    end
    @politicians = @politicians.page(params[:page]).per(10) if @politicians
    @citizens    = @citizens.page(params[:page]).per(10) if @citizens
  end
  private :paginate
end


