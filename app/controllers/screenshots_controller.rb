class ScreenshotsController < ApplicationController
  # GET /screenshots
  # GET /screenshots.xml
  def index
    @screenshots = Screenshot.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @screenshots }
    end
  end

  # GET /screenshots/1
  # GET /screenshots/1.xml
  def show
    @screenshot = Screenshot.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @screenshot }
      format.json { render :json => @screenshot }
    end
  end

  # GET /screenshots/new
  # GET /screenshots/new.xml
  def new
    @screenshot = Screenshot.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @screenshot }
    end
  end

  # GET /screenshots/1/edit
  def edit
    @screenshot = Screenshot.find(params[:id])
  end

  # POST /screenshots
  # POST /screenshots.xml
  def create
    @screenshot = Screenshot.new(params[:screenshot])

    respond_to do |format|
      if @screenshot.save
        flash[:notice] = 'Screenshot was successfully created.'
        format.html { redirect_to(@screenshot) }
        format.xml  { render :xml => @screenshot, :status => :created, :location => @screenshot }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @screenshot.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /screenshots/1
  # PUT /screenshots/1.xml
  def update
    @screenshot = Screenshot.find(params[:id])

    respond_to do |format|
      if @screenshot.update_attributes(params[:screenshot])
        flash[:notice] = 'Screenshot was successfully updated.'
        format.html { redirect_to(@screenshot) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @screenshot.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /screenshots/1
  # DELETE /screenshots/1.xml
  def destroy
    @screenshot = Screenshot.find(params[:id])
    @screenshot.destroy

    respond_to do |format|
      format.html { redirect_to(screenshots_url) }
      format.xml  { head :ok }
    end
  end
end
