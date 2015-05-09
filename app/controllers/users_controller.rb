class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update_email]
  respond_to :html

  def edit
    @user = User.find(params[:id])
  end

  def update_email
    if @user.update(permitted_params)
      sign_in @user, :bypass => true
      redirect_to root_path, notice: 'Signed in successfully'
    else
      render :edit
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def permitted_params
      params.require(:user).permit(:email)
    end
end