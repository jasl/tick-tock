
class MomentsController < ApplicationController
  before_filter :authenticate_user!

  # GET /moments
  # GET /moments.json
  def index
    @moments = current_user.Moment

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @moments }
    end
  end

  # GET /moments/1
  # GET /moments/1.json
  def show
    @moment = Moment.where(user_id: current_user.id).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @moment }
    end
  end

  # GET /moments/new
  # GET /moments/new.json
  def new
    @moment = Moment.new
    @moment.build_note
    @moment.build_photo

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @moment }
    end
  end

  # GET /moments/1/edit
  def edit
    @moment = Moment.where(user_id: current_user.id).find(params[:id])
  end

  # POST /moments
  # POST /moments.json
  def create
    @moment = Moment.new(params[:moment])
    @moment.user = current_user

    types = []
    params[:moment].each {|key, value| types<</(\w+)_attributes/.match(key).captures[0].to_sym if value.class == ActiveSupport::HashWithIndifferentAccess}
    types.each.inject(true) do |flag,type|
      @moment.send("build_#{type}") if @moment.send(type).nil?

      if @moment.send(type).filled? and flag
        @moment.type = type
        flag = false
      end
      flag
    end

    respond_to do |format|
      if @moment.save
        format.html { redirect_to @moment, notice: 'Moment was successfully created.' }
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
    @moment = Moment.where(user_id: current_user.id).find(params[:id])

    respond_to do |format|
      if @moment.update_attributes(params[:moment])
        format.html { redirect_to @moment, notice: 'Moment was successfully updated.' }
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
    @moment = Moment.where(user_id: current_user.id).find(params[:id])
    @moment.destroy

    respond_to do |format|
      format.html { redirect_to moments_url }
      format.json { head :no_content }
    end
  end
end
