# Controller for Tasks module
class TasksController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user
  before_action :find_project
  before_action :find_task, only: %i[edit update destroy]
  def index
    @task_feed = Kaminari.paginate_array(@project.task_feed).page(params[:page])
  end

  def new
    @task = @project.tasks.build
  end

  def edit
    @task = Task.find_by(id: params[:id])
  end

  def create
    @task = @project.tasks.build(task_params)

    if @task.save
      flash[:success] = 'Task successfully created!'
      redirect_to root_path
    else
      flash[:danger] = 'Something went wrong'
      render 'new', status: 422
    end
  end

  def update
    if @task.update(task_params)
      flash[:success] = 'Successfully Updated'
      redirect_to root_path
    else
      flash[:danger] = 'Something went wrong'
      render 'edit', status: 422
    end
  end

  def destroy
    @task.destroy
    redirect_to root_path
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def find_task
    @task = @project.tasks.find(params[:id])
  rescue StandardError
    flash[:danger] = 'Not Authorized'
    redirect_to root_path
  end

  def task_params
    params.require(:task).permit(:description, :status)
  end

  def signed_in_user
    redirect_to signin_path unless user_is_signed_in?
  end

  def correct_user
    project = Project.find_by(id: params[:project_id])
    redirect_to root_path unless current_user?(project.user) || current_user.admin?
  end
end
