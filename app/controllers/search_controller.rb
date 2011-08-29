class SearchController < ApplicationController
  skip_before_filter :authenticate_user!,    :only => [:show]

  def show
    @search = OpenStruct.new(:q => params[:q])

    @contents = AreaPublicStream.only_contents.search @search.q

    users     = User.search_by_name_description_province_and_city @search.q
    @citizens = users.citizens
    @politics = users.politics

    @areas = @politics.inject([]){|arr, x| arr + x.areas}.uniq! if params[:type].present? && params[:type] == 'politics'

  end
end