class MomentsController < ApplicationController
  before_filter :authenticate_user!


  def wall
    #@moments = []
    #
    #total_moments = current_user.moments.length
    #if total_moments <= Settings['moments_on_wall']
    #  @moments = current_user.moments.all
    #else
    #  random_ids = get_random_numbers(total_moments-1, Settings['moments_on_wall'])
    #  random_ids.each { |id| @moments<<current_user.moments[id] unless current_user.moments[id].nil? }
    #  (@moments.sort_by! { |moment| moment.full_time }).reverse!
    #end

    @moment = nil
    total_moments = current_user.moments.length
    @moment = current_user.moments[rand(total_moments)] if total_moments > 0

    respond_to do |format|
      format.html { @page_title = t("views.moment.titles.wall") } # index.html.erb
      format.json { render json: @moment.nil? ? nil : @moment  }
    end
  end

  # GET /moments
  # GET /moments.json
  def index
    @moments = current_user.moments.all

    respond_to do |format|
      format.html { @page_title = t("views.moment.titles.index") } # index.html.erb
      format.json { render json: @moments }
    end
  end

  # GET /moments/1
  # GET /moments/1.json
  def show
    @moment = current_user.moments.find(params[:id])

    respond_to do |format|
      format.html { @page_title = t("views.moment.titles.show") } # show.html.erb
      format.json { render json: @moment }
    end
  end

  # GET /moments/new
  # GET /moments/new.json
  def new
    @moment = Moment.new
    @moment.build_all!
    @moment.build_time!

    respond_to do |format|
      format.html { @page_title = t("views.moment.titles.new") } # new.html.erb
      format.json { render json: @moment }
    end
  end

  # GET /moments/1/edit
  def edit
    @moment = current_user.moments.find(params[:id])
  end

  # POST /moments
  # POST /moments.json
  def create
    @moment = current_user.moments.build params[:moment]

    respond_to do |format|
      if @moment.save
        format.html { redirect_to @moment, notice: t('views.moment.messages.saved') }
        format.json { render json: @moment, status: :created, location: @moment }
      else
        format.html { render action: "new" }
        format.json { render json: @moment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /moments/1
  # PUT /moments/1.json
  def update
    @moment = current_user.moments.find(params[:id])

    respond_to do |format|
      if @moment.update_attributes(params[:moment])
        format.html { redirect_to @moment, notice: t('views.moment.messages.updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @moment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /moments/1
  # DELETE /moments/1.json
  def destroy
    @moment = current_user.moments.find(params[:id])
    @moment.destroy

    respond_to do |format|
      format.html { redirect_to moments_url }
      format.json { head :no_content }
    end
  end

  private

  def get_random_numbers(max, count)
    r = []
    until r.length == count
      n = rand(max)
      r<<n unless r.include? n
    end
    r
  end
end
