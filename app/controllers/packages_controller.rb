class PackagesController < ApplicationController
  
  def index
  end
  
  def show
   # @package = Package.find(params[:id])
    
    if params[:depot_id]
      @depot = Depot.find(params[:depot_id])
      @package = @depot.packages.find(params[:id])
    else
      @package = Package.find(params[:id])
      @depot = Depot.find(@package.depot_id)
    end
    
    add_breadcrumb "Depots", depots_path
    add_breadcrumb @depot.dep_name, depot_path(@depot)
    
  end
  
  def new
    @depot = Depot.find(params[:depot_id])
    @package = Package.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @package }
    end
  end
  
  def create
        
    @depot = Depot.find(params[:depot_id])
    @package = @depot.packages.create(params[:package])
    
    respond_to do |format|    
      if @package.save
        package_url = @package.pkg_name
        package_url = package_url[0, 24]
        package_url = package_url.gsub(' ', '_')
        package_url = package_url + "#{@package.id}".to_s
        @package.pkg_url = package_url
        @package.save        
        depot_url   = @depot.dep_url
        dir = DEPOT_ROOT + "/" + "#{depot_url}"
        dir += "/" + "#{package_url}" 
        # make sure no goofy chars in string
        special = "?<>.',?[]}{=-)(*&^%$#`~{}"
        regex = /[#{special.gsub(/./){|char| "\\#{char}"}}]/
        if package_url =~ regex
          @package.destroy
          format.html { redirect_to @depot, :alert => "ERROR: Illegal characters in name." }
          format.json { head :no_content }
        else
          Logg3r.info Time.now.to_s + " - creating package: " + package_url + " at " + dir
          FileUtils.mkdir dir
          format.html { redirect_to @depot, notice: t(:package_created) }
          format.json { render json: @depot, status: :created, location: @package }
        end
      else
        format.html { render action: "new" }
        format.json { render json: @package.errors, status: :unprocessable_entity }
      end
    end    
    
  end
  
  def edit
    @package = Package.find(params[:id])
    @depot = Depot.find(@package.depot_id)

    add_breadcrumb "Depots", depots_path
    add_breadcrumb @depot.dep_name, depot_path(@depot)

  end
  
  def update
    @package = Package.find(params[:id])

    respond_to do |format|
      if @package.update_attributes(params[:package])
        format.html { redirect_to @package, notice: t(:package_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @package.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @depot = Depot.find(params[:depot_id])
    @package = @depot.packages.find(params[:id])
    
    depot_url   = @depot.dep_url
    package_url = @package.pkg_url
    dir = DEPOT_ROOT + "/" + "#{depot_url}" + "/" + "#{package_url}"
    
    respond_to do |format|
      if FileTest.exists?(dir)
        Logg3r.info Time.now.to_s + " - destroying package: " + package_url + " at " + dir
        FileUtils.rm_r dir
        @package.destroy
        format.html { redirect_to @depot, :notice => t(:package_deleted) }
        format.json { head :no_content }
      else
        format.html { redirect_to @depot, :alert => "INTERNAL ERROR: Cannot locate package at: #{dir}" }
        format.json { head :no_content }
      end
    end  
  end
  
end
