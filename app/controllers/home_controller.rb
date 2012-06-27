class HomeController < ApplicationController
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
