class DemoController < ApplicationController

  skip_before_filter :authenticate_user!

  def index
  end

  def static
  end

end

