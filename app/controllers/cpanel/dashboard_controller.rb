class Cpanel::DashboardController < ApplicationController
  layout 'cpanel'

  before_filter :must_admin

  def index
  end

  private
  def must_admin
    authenticate_user!
    redirect_to root_path unless current_user.admin?
  end
end
