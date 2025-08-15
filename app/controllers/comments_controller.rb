class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post
  before_action :set_comment, only: [:show, :update, :destroy]
  before_action :authorize_user!, only: [:update, :destroy]

  # GET /posts/:post_id/comments
  def index
    render json: @post.comments, include: :user
  end

  # GET /posts/:post_id/comments/:id
  def show
    render json: @comment, include: :user
  end

  # POST /posts/:post_id/comments
  def create
    @comment = @post.comments.build(comment_params.merge(user: current_user))
    if @comment.save
      render json: @comment, status: :created
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/:post_id/comments/:id
  def update
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /posts/:post_id/comments/:id
  def destroy
    @comment.destroy
    head :no_content
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def authorize_user!
    render json: { error: "Not authorized" }, status: :forbidden unless @comment.user == current_user
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
