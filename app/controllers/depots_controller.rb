class DepotsController < ApplicationController
  
  def index
    #@depots = Depot.order(sort_column + ' ' + sort_direction)
    @depots = Depot.find(:all, :order => 'dep_name')
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @depots }
    end
  end

  def show
    @depot = Depot.find(params[:id])
    add_breadcrumb "Depots", depots_path

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @depot }
    end
  end

  def new
    @depot = Depot.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @depot }
    end
  end

  def edit
    @depot = Depot.find(params[:id])
  end

  def create
    @depot = Depot.new(params[:depot])
    
    respond_to do |format|    
      if @depot.save
        depot_url = @depot.dep_name
        depot_url = depot_url[0, 24]
        depot_url = depot_url.gsub(' ', '_')
        depot_url = depot_url + "_" + "#{@depot.id}".to_s
        @depot.dep_url = depot_url
        @depot.save
        dir = DEPOT_ROOT + "/" + "#{depot_url}"
        # make sure no goofy chars in string
        special = "?<>.',?[]}{=-)(*&^%$#`~{}"
        regex = /[#{special.gsub(/./){|char| "\\#{char}"}}]/
        #
        # if find.byname(@depot.dep_name) is true
        # error depot names must be unique
        #
        if depot_url =~ regex
          @depot.destroy
          format.html { redirect_to depots_url, :alert => "ERROR: Illegal characters in name." }
          format.json { head :no_content }
        else
          Logg3r.info Time.now.to_s + " - creating depot: " + depot_url + " at " + dir
          FileUtils.mkdir dir
          format.html { redirect_to @depot, notice: t(:depot_created) }
          format.json { render json: @depot, status: :created, location: @depot }
        end
      else
        format.html { render action: "new" }
        format.json { render json: @depot.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @depot = Depot.find(params[:id])

    respond_to do |format|
      if @depot.update_attributes(params[:depot])
        format.html { redirect_to @depot, notice: t(:depot_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @depot.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @depot = Depot.find(params[:id])
    depot_url = @depot.dep_url

    dir = DEPOT_ROOT + "/" + "#{depot_url}"
    
    respond_to do |format|
      if FileTest.exists?(dir)
        Logg3r.info Time.now.to_s + " - destroying depot: " + depot_url + " at " + dir
        FileUtils.rm_r dir
        @depot.destroy
        format.html { redirect_to depots_url, :notice => t(:depot_deleted) }
        format.json { head :no_content }
      else
        format.html { redirect_to depots_url, :alert => "INTERNAL ERROR: Cannot locate depot at: #{dir}" }
        format.json { head :no_content }
      end
    end
  end
  
end
