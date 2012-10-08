class ArtifactsController < ApplicationController
  
  def index
     #Logg3r.debug Time.now.to_s + ": index: getting depots"
     @artifacts = Artifact.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @artifacts }
    end
  end
  
  def show
    @artifact = Artifact.find(params[:id])
    
    @package = Package.find(params[:package_id])
    @depot = Depot.find(@package.depot_id)
    add_breadcrumb "Depots", depots_path
    add_breadcrumb @depot.dep_name, depot_path(@depot)
    add_breadcrumb @package.pkg_name, package_path(@package)
  end
  
  def new
     @package = Package.find(params[:package_id])
     @artifact = Artifact.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @artifact }
    end
  end
  
  def create   
    if params[:depot_id]
      @depot = Depot.find(params[:depot_id])
      @package = @depot.packages.find(params[:id])
    else
      @package = Package.find(params[:package_id])
      @depot = Depot.find(@package.depot_id)
    end
    
    depot_url = @depot.dep_url
    package_url = @package.pkg_url
    dir = DEPOT_ROOT + "/" + depot_url + "/" + package_url
    
    @artifact = @package.artifacts.create(params[:artifact])
    
    respond_to do |format|    
      if @artifact.save
        upload_url = @artifact.art_url
        artifact_url = File.basename(@artifact.art_url)
        artifact_url = artifact_url[0, 24]
        artifact_url = artifact_url.gsub(' ', '_')
        @artifact.art_url = artifact_url
        @artifact.save
    
        input = upload_url
        output = File.join(dir, File.basename(input)) 

        if FileTest.exist?(input)
          if !FileTest.exists?(output)
            # make sure no goofy chars in string
            special = "?<>',?[]}{=-)(*&^%$#`~{}"
            regex = /[#{special.gsub(/./){|char| "\\#{char}"}}]/
            if artifact_url =~ regex
              @artifact.destroy
              format.html { redirect_to @package, :alert => "ERROR: Illegal characters in name." }
              format.json { head :no_content }
            else
              Logg3r.info Time.now.to_s + " - creating artifact: " + artifact_url + " at " + dir
              FileUtils.cp input, output
              format.html { redirect_to @package, notice: t(:artifact_created) }
              format.json { render json: @package, status: :created, location: @package }
            end
          else
            @artifact.destroy
            format.html { redirect_to @package, :alert => "ERROR: Artifact already in package: #{output}" }
            format.json { head :no_content }
          end
        else
          @artifact.destroy
          format.html { redirect_to @package, :alert => "ERROR: Cannot locate input at: #{input}" }
          format.json { head :no_content }
        end
      else
        format.html { render action: "new" }
        format.json { render json: @artifact.errors, status: :unprocessable_entity }
      end
    end       
  end
  
  def edit
    @artifact = Artifact.find(params[:id])
   
    @package = Package.find(@artifact.package_id)
    @depot = Depot.find(@package.depot_id)
    add_breadcrumb "Depots", depots_path
    add_breadcrumb @depot.dep_name, depot_path(@depot)
    add_breadcrumb @package.pkg_name, package_path(@package)
  end
   
   def update
    @artifact = Artifact.find(params[:id])
    @package = Package.find(@artifact.package_id)

    respond_to do |format|
      if @artifact.update_attributes(params[:artifact])
        format.html { redirect_to @package, notice: t(:artifact_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @artifact.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    if params[:depot_id]
      @depot = Depot.find(params[:depot_id])
      @package = @depot.packages.find(params[:id])
    else
      @package = Package.find(params[:package_id])
      @depot = Depot.find(@package.depot_id)
    end
    
    depot_url   = @depot.dep_url
    package_url = @package.pkg_url
    
    @artifact = Artifact.find(params[:id])
    artifact_url = @artifact.art_url
    dir = DEPOT_ROOT + "/" + @depot.dep_url + "/" + @package.pkg_url + "/" + @artifact.art_url  
   
    respond_to do |format|
      if FileTest.exists?(dir)
        Logg3r.info Time.now.to_s + " - destroying artifact: " + artifact_url + " at " + dir
        FileUtils.rm dir
        @artifact.destroy
        format.html { redirect_to @package, :notice => t(:artifact_deleted) }
        format.json { head :no_content }
      else
        format.html { redirect_to @package, :alert => "INTERNAL ERROR: Cannot locate artifact at: #{dir}" }
        format.json { head :no_content }
      end
    end      
  end
  
end
