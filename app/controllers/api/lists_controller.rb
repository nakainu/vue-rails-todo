class Api::ListsController < ApplicationController

  # GET /lists
  def index
    # 後々のため、更新順で返します
    @lists = List.order('updated_at DESC')
  end

  # POST /lists
  def create
    @list = List.new(list_params)

    if @list.save
      render :show, status: :created
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /lists/1
  def update
    @list = List.find(params[:id])
    if @list.update(list_params)
      render :show, status: :ok
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def list_params
      params.fetch(:list, {}).permit(
          :name, :is_done
      )
    end
end
