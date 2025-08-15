class PostsController < ApplicationController
  
  before_action :authenticate_user!, except: [:index, :show]
  
  
  before_action :set_post, only: [:show, :update, :destroy]

  
  before_action :authorize_user!, only: [:update, :destroy]

  
  def index
    if params[:user_id] # When hitting /users/:user_id/posts
      posts = Post.where(user_id: params[:user_id])
    else
      posts = Post.order(created_at: :desc)
    end

    render json: posts.as_json(
      include: [:user, :tags, :comments],
      methods: [:image_url]
    )
  end

  
  def show
    render json: @post.as_json(
    include: [:user, :tags, :comments],
    methods: [:image_url]
  )
  end

  
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      render json: @post, status: :created
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  
  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  
  def destroy
    @post.destroy
    head :no_content
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_user!
    render json: { error: "Not authorized" }, status: :forbidden unless @post.user == current_user
  end

  def post_params
    params.require(:post).permit(:title, :body,:image,  tag_ids: [])
  end
end
