class Api::TodosController < ApplicationController

  # GET /todos
  def index
    # 後々のため、更新順で返します
    @todos = Todo.order('updated_at DESC')
  end

  # POST /todos
  def create
    @todo = Todo.new(todo_params)

    if @todo.save
      render :show, status: :created
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /todos/1
  def update
    @todo = Todo.find(params[:id])
    if @todo.update(todo_params)
      render :show, status: :ok
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def todo_params
      params.fetch(:todo, {}).permit(
          :name, :is_done, :list_id
      )
    end
end
