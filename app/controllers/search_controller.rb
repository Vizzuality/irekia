class SearchController < ApplicationController
  skip_before_filter :authenticate_user!,    :only => [:show]

  def show
    @search = OpenStruct.new(params[:search])

    @contents = AreaPublicStream.only_contents.search @search.query

    users     = User.search_by_name_description_province_and_city @search.query
    @citizens = users.citizens
    @politicians = users.politicians

    contents_areas    = @contents.inject([]){|arr, content| arr + [content.area]}.uniq! || []
    citizens_areas    = @citizens.inject([]){|arr, citizen| arr + citizen.areas}.uniq! || []
    politicians_areas = @politicians.inject([]){|arr, politician| arr + politician.areas}.uniq! || []
    @areas = contents_areas + citizens_areas + politicians_areas

    if request.xhr?
      head(:not_found) and return if @areas.blank? && @contents.blank? && @citizens.blank? && @politicians.blank?
      render :autocomplete, :layout => false and return
    end

  end

end

