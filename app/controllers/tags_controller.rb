class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
 

  # GET /tags
  def index
    if params[:q].present?
      @tags = Tag.where("name ILIKE ?", "%#{params[:q]}%")
    else
      @tags = Tag.all
    end
    render json: @tags
  end

  # GET /tags/:id
  def show
    render json: @tag
  end

  # POST /tags
  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      render json: @tag, status: :created
    else
      render json: { errors: @tag.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tags/:id
  def update
    if @tag.update(tag_params)
      render json: @tag
    else
      render json: { errors: @tag.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /tags/:id
  def destroy
    @tag.destroy
    head :no_content
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end
