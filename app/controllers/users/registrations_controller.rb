# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    build_resource(sign_up_params)

    if resource.save
      render json: {
        message: 'Signed up successfully.',
        user: user_json(resource)
      }, status: :created
    else
      render json: {
        message: 'Sign up failed.',
        errors: resource.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :image)
  end

  def user_json(user)
    {
      id: user.id,
      name: user.name,
      email: user.email,
      image_url: user.image  # just a string now
    }
  end
end
