# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: {
      message: 'Logged in successfully.',
      user: {
        id: resource.id,
        name: resource.name,
        email: resource.email,
        image_url: resource.image  # just a string
      }
    }, status: :ok
  end

  def respond_to_on_destroy
    if current_user
      render json: { message: 'Logged out successfully.' }, status: :ok
    else
      render json: { message: 'User has no active session.' }, status: :unauthorized
    end
  end
end
