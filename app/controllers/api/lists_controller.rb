class Api::ListsController < ApplicationController

  # GET /lists
  def index
    #更新順で返す
    @lists = List.order('updated_at DESC')
  end

  # POST /lists
  def create
    @list = List.new(list_prams)

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
    def list_params
      params.fetch(:list, {}).permit(
        :name
      )
    end
  end
