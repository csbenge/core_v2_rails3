require 'socket'

class WorkersController < ApplicationController
  # GET /workers
  # GET /workers.json
  def index
    @workers = Worker.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @workers }
    end
  end

  # GET /workers/1
  # GET /workers/1.json
  def show
    @worker = Worker.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @worker }
    end
  end

  # GET /workers/new
  # GET /workers/new.json
  def new
    @worker = Worker.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @worker }
    end
  end

  # GET /workers/1/edit
  def edit
    @worker = Worker.find(params[:id])
  end

  # POST /workers
  # POST /workers.json
  def create
    @worker = Worker.new(params[:worker])

    respond_to do |format|
      if @worker.save
        format.html { redirect_to @worker, notice: 'Worker was successfully created.' }
        format.json { render json: @worker, status: :created, location: @worker }
      else
        format.html { render action: "new" }
        format.json { render json: @worker.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /workers/1
  # PUT /workers/1.json
  def update
    @worker = Worker.find(params[:id])

    respond_to do |format|
      if @worker.update_attributes(params[:worker])
        format.html { redirect_to @worker, notice: 'Worker was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @worker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /workers/1
  # DELETE /workers/1.json
  def destroy
    @worker = Worker.find(params[:id])
    @worker.destroy

    respond_to do |format|
      format.html { redirect_to workers_url }
      format.json { head :no_content }
    end
  end
  
#======================================#
# test connect to worker
#======================================#
  
  def test
    @worker = Worker.find(params[:id])

    $clientSession = nil

    # Connect to Worker and authenticate
    begin
      $clientSession = TCPSocket.new(@worker.wrk_host, @worker.wrk_port.to_i)
    rescue Exception => e
      respond_to do |format|
        format.html { redirect_to @worker, alert: 'Cannot connect to agent: ' + @worker.wrk_name.chomp }
        format.json { head :no_content }
      end
    else
      $clientSession.puts @worker.wrk_auth_token
      workerResponse = $clientSession.gets
    
      if workerResponse.include? "UNAUTHORIZED"
        respond_to do |format|
          format.html { redirect_to @worker, alert: 'Not authorized to access agent: '  + @worker.wrk_name.chomp }
          format.json { head :no_content }
        end
      else
        $clientSession.puts '.os'
        workerResponse = $clientSession.gets
        respond_to do |format|
          format.html { redirect_to @worker, notice: workerResponse }
          format.json { head :no_content }
        end
      end
    end
  end
end
