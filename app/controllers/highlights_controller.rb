class HighlightsController < ApplicationController

  layout :layout

  def layout
    case params[:action]
      when "new" : "home"
      when "edit" : "editor"
      when "show" : "viewer"
    end
  end

  def index
    @highlights = Highlight.all
    respond_to do |format|
      format.html
      format.xml  { render :xml => @highlights }
    end
  end

  def show
    @highlight = Highlight.find(params[:id])
    respond_to do |format|
      format.html
      format.xml  { render :xml => @highlight }
      format.json  { render :json => @highlight }
    end
  end

  def new
    @highlight = Highlight.new
    respond_to do |format|
      format.html
      format.xml  { render :xml => @highlight }
    end
  end

  def edit
    @highlight = Highlight.find(params[:id])
    @highlight.make_tiny_url(url_for(@highlight))
    respond_to do |format|
      format.html
      format.xml  { render :xml => @highlight }
      format.js  { render :json => @highlight }
    end
  end

  def create
    @highlight = Highlight.new(params[:highlight])
    respond_to do |format|
      if @highlight.save
        flash[:notice] = 'Highlight was successfully created.'
        format.html { redirect_to(edit_highlight_url(@highlight)) }
        format.xml  { render :xml => @highlight, :status => :created, :location => @highlight }
      else
        flash[:warning] = 'Url was invalid'
        format.html { render :action => "new" }
        format.xml  { render :xml => @highlight.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @highlight = Highlight.find(params[:id])
    params[:highlight] ||= {}
    params.each_pair do |k,v|
       params[:highlight][k.to_sym] = v if @highlight.class.column_names.include?(k) and k.to_sym != :id
    end
    #@highlight.update_attributes(params[:highlight]) if params[:highlight][:from] == "ajax"
    respond_to do |format|
      if @highlight.update_attributes(params[:highlight])
        flash[:notice] = 'Highlight was successfully updated.'
        format.html { redirect_to(@highlight) }
        format.xml  { head :ok }
        format.json  { render :json => @highlight }
        format.js  { render :json => @highlight }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @highlight.errors, :status => :unprocessable_entity }
        format.js  { render :json => @highlight.errors, :status => :unprocessable_entity }
        format.json  { render :json => @highlight.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @highlight = Highlight.find(params[:id])
    @highlight.destroy
    respond_to do |format|
      format.html { redirect_to(highlights_url) }
      format.xml  { head :ok }
    end
  end

end