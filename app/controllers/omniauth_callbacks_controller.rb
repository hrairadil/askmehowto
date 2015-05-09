class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_user, only: [:facebook, :twitter]
  before_action :provider_sign_in, only: [:facebook, :twitter]


  def facebook
  end

  def twitter
  end

  private
    def set_user
      @user = User.find_for_oauth(request.env['omniauth.auth'])
    end

    def provider_sign_in
      if @user.persisted? && @user.email_verified?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: action_name.capitalize) if is_navigational_format?
      else
        redirect_to edit_user_path @user
      end
    end
end

