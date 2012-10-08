class RolesController < ApplicationController
 
  # GET /roles
  # GET /roles.json
  def index
    @roles = Role.order(sort_column + ' ' + sort_direction)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @roles }
    end
  end

  # GET /roles/1
  # GET /roles/1.json
  def show
    @role = Role.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @role }
    end
  end

  # GET /roles/new
  # GET /roles/new.json
  def new
    @role = Role.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @role }
    end
  end

  # GET /roles/1/edit
  def edit
    @role = Role.find(params[:id])
  end

  # POST /roles
  # POST /roles.json
  def create
    @role = Role.new(params[:role])

    @perms = params[:permissions["permissions"]]
    if @perms != nil
      @permissions = @perms["permissions"]
    end
    #logger.debug "PERMISSIONS: #{@permissions.inspect}"
    if @permissions == nil
      @role.read = 0
      @role.write = 0
      @role.execute = 0
    end
    if @permissions != nil
      if @permissions.include?("read")
        @role.read = 1
      else
        @role.read = 0
      end
      if @permissions.include?("write")
        @role.write = 1
      else
        @role.write = 0
      end
      if @permissions.include?("execute")
        @role.execute = 1
      else
        @role.execute = 0
      end
    end
        
    respond_to do |format|
      if @role.save
        format.html { redirect_to @role, notice: t(:role_created) }
        format.json { render json: @role, status: :created, location: @role }
      else
        format.html { render action: "new" }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /roles/1
  # PUT /roles/1.json
  def update
    @role = Role.find(params[:id])
    
    @perms = params[:permissions["permissions"]]
    if @perms != nil
      @permissions = @perms["permissions"]
    end
    #logger.debug "PERMISSIONS: #{@permissions.inspect}"
    if @permissions == nil
      @role.read = 0
      @role.write = 0
      @role.execute = 0
    end
    if @permissions != nil
      if @permissions.include?("read")
        @role.read = 1
      else
        @role.read = 0
      end
      if @permissions.include?("write")
        @role.write = 1
      else
        @role.write = 0
      end
      if @permissions.include?("execute")
        @role.execute = 1
      else
        @role.execute = 0
      end
    end

    respond_to do |format|
      if @role.update_attributes(params[:role])
        format.html { redirect_to @role, notice: t(:role_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.json
  def destroy
    @role = Role.find(params[:id])
    
    @users = User.find_by_role_id(@role.id)
    respond_to do |format|
      if @users == nil
        @role.destroy
        format.html { redirect_to roles_url, :notice => t(:role_deleted) }
        format.json { head :no_content }
      else
        format.html { redirect_to roles_url, :alert => t(:role_inuse) }
        format.json { head :no_content }
      end
    end
  end
  
end
