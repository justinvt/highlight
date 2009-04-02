class WebThumbsController < ApplicationController
  # GET /web_thumbs
  # GET /web_thumbs.xml
  def index
    @web_thumbs = WebThumb.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @web_thumbs }
    end
  end

  # GET /web_thumbs/1
  # GET /web_thumbs/1.xml
  def show
    @web_thumb = WebThumb.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @web_thumb }
    end
  end

  # GET /web_thumbs/new
  # GET /web_thumbs/new.xml
  def new
    @web_thumb = WebThumb.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @web_thumb }
    end
  end

  # GET /web_thumbs/1/edit
  def edit
    @web_thumb = WebThumb.find(params[:id])
  end

  # POST /web_thumbs
  # POST /web_thumbs.xml
  def create
    @web_thumb = WebThumb.new(params[:web_thumb])

    respond_to do |format|
      if @web_thumb.save
        flash[:notice] = 'WebThumb was successfully created.'
        format.html { redirect_to(@web_thumb) }
        format.xml  { render :xml => @web_thumb, :status => :created, :location => @web_thumb }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @web_thumb.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /web_thumbs/1
  # PUT /web_thumbs/1.xml
  def update
    @web_thumb = WebThumb.find(params[:id])

    respond_to do |format|
      if @web_thumb.update_attributes(params[:web_thumb])
        flash[:notice] = 'WebThumb was successfully updated.'
        format.html { redirect_to(@web_thumb) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @web_thumb.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /web_thumbs/1
  # DELETE /web_thumbs/1.xml
  def destroy
    @web_thumb = WebThumb.find(params[:id])
    @web_thumb.destroy

    respond_to do |format|
      format.html { redirect_to(web_thumbs_url) }
      format.xml  { head :ok }
    end
  end
end
