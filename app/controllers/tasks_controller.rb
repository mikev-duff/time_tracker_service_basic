class TasksController < ApplicationController
require 'gchart'
before_filter :authenticate
before_filter :fetch_task_for_user, :only => [:show, :edit, :update, :destroy]

  # GET /tasks
  # GET /tasks.json
  def index

@graph = Gchart.pie_3d(:title => 'Tasks', :size => '400x200',
                       :data => [10, 45, 45], :labels => ["Duff", "Nest", "Other"] )

    @tasks = Task.find_all_by_user_id(@user.id)
    #@tasks = Task.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.json
  def new
    @task = @user.tasks.build(params[:task])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
     @task = @user.tasks.build(params[:task])
     project = Project.find_by_name(params[:task][:project_name])
     @task.project = project

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render json: @task, status: :created, location: @task }
      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.json
  def update
     project = Project.find_by_name(params[:task][:project_name])
     @task.project = project

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render json: @task }
      else
        format.html { render action: "edit" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url }
      format.json { head :no_content }
    end
  end


  protected

  def authenticate
    authenticate_or_request_with_http_basic('Login') do |username, password|
        @user = User.find_by_email(username)
        @user && @user.authenticate(password)
    end
  end

  def fetch_task_for_user
    @task = Task.find(:first, :conditions => {:user_id => @user.id, :id => params[:id]})
  end


end
