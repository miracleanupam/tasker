class ProjectsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, only: %i[update destroy]
  before_action :find_project, only: %i[edit update destroy]
  def index
    @project_feed = Kaminari.paginate_array(current_user.project_feed).page(params[:page])
    @tasks_feed_per_project = {}
    @project_feed.each do |p|
      tasks_feed_for_project = p.task_feed
      case params[:"filter_#{p.id}"]
      when 'all'
      when nil
      else
        tasks_feed_for_project = tasks_feed_for_project.where(status: params[:"filter_#{p.id}"])
      end
      puts params[:"filter_#{p.id}"]
      if !!params[:"search_#{p.id}"]
        search_term = params[:"search_#{p.id}"].downcase
        tasks_feed_for_project = tasks_feed_for_project.where('lower(description) like ?', "%#{search_term}%")
      end

      @tasks_feed_per_project[p.id] = Kaminari.paginate_array(tasks_feed_for_project).page(params[:"pagina_#{p.id}"])
    end
  end

  def new
    @project = Project.new
    @tasks = @project.tasks.build
  end

  def edit; end

  def create
    @project = current_user.projects.build(project_params)

    if @project.save
      flash[:success] = 'New Project Successfully Created!'
      redirect_to root_path
    else
      flash[:danger] = 'Something went wrong!'
      # redirect_to root_path
    end
  end

  def update
    if @project.update(project_params)
      flash[:success] = 'Successfully Updated'
      redirect_to root_url
    else
      flash[:danger] = 'something went wrong'
      render 'edit', status: 422
    end
  end

  def destroy
    @project.destroy
    flash[:success] = 'Project successfully deleted!'
    redirect_to root_path
  end

  def tasks_in_project
    Kaminari.paginate_array(@project.tasks).page(params[:page])
  end

  private

  def find_project
    @project = Project.find_by(id: params[:id])
  end

  def project_params
    params.require(:project).permit(
      :name,
      tasks_attributes: %i[description status]
    )
  end

  def signed_in_user
    redirect_to signin_path unless user_is_signed_in?
  end

  def correct_user
    @project = Project.find_by(id: params[:id])
    redirect_to root_path unless current_user?(@project.user) || current_user.admin?
  end
end
