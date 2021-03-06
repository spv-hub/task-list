class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find_by_id(params[:id])
    if @task.nil?
      redirect_to action: :index
      return
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params) #instantiate a new book
    if @task.save # save returns true if the database insert succeeds
      redirect_to action: :index # go to the index so we can see the book in the list
      return
    else # save failed :(
    render :new, :bad_request# show the new book form view again
    return
    end
  end

  def edit
    @task = Task.find_by_id(params[:id])
    if @task.nil?
      redirect_to action: :index
      return
    end
  end

  def update
    @task = Task.find_by_id(params[:id])
    if @task.nil?
      redirect_to action: :index
      return
    elsif @task.update(task_params)
      redirect_to action: :index
      return
    else
      render :edit
      return
    end
  end

  def destroy
    @task = Task.find_by_id(params[:id])
    if @task.nil?
      redirect_to action: :index, status: :not_found
      return
    end

    if @task.destroy
      flash[:success] = 'It worked!'
    else
      head :not_found
    end
    redirect_to action: :index
  end

  def toggle_complete
    task = Task.find_by_id(params[:id])
    if task.completed_at.nil?
      task.completed_at = Time.now
    else
      task.completed_at = nil
    end
    task.save
    redirect_to action: :index
  end

  private
  def task_params
    return params.require(:task).permit(:name, :description, :completed_at)
  end
end
