class HomeController < ApplicationController
  before_filter :authenticate_user!, :only => [:dashboard]

  caches_page :about

  def index
    if current_user
      redirect_to moments_wall_path
    else
      redirect_to about_path
    end
  end

  def about

  end

  def dashboard

  end
end
