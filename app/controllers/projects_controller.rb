class ProjectsController < ApplicationController
  before_action :require_login, only: [:edit, :update, :destroy, :new, :create]
  before_action :disallow_moderator, only: [:create, :new]
  before_action :set_project, only: [:show, :edit, :update, :destroy, :complete]
  # GET /projects
  # GET /projects.json
  def index
    # @user = current_user
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show

    @responses = @project.responses
    @pending = @responses.where(is_approved: false, is_hidden: false)
    @approved = @responses.where(is_approved: true, is_hidden: false)

    @capacity_tooltip_label = (@project.max_people==0)? "No capacity limit!" : "For #{@project.max_people} people"
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      @project.user_id = current_user.id
      # @project.chatroom_id = @project.id
      if @project.save
        x = Chatroom.new
        x.project_id = @project.id
        x.save  
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # Marks the project as completed
  def complete
    @project.update(is_complete: true)
    redirect_to project_path(@project.id)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params.require(:project).permit(:title, :category, :estimated_time, :max_people, :location, :longitude, :latitude, {images:[]}, :detail, :user_id)
  end

  # def chatroom_params
  #   params.require(:chatroom).permit(:topic, :slug)
  # end
end
