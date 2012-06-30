class HomeController < ApplicationController

  caches_page :about

  def index
    if current_user
      redirect_to wall_moments_path
    else
      redirect_to about_path
    end
  end

  def about

  end
end
