class UsersController < ApplicationController

  def show
    @user = User.find_by_username!(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to Ledger!"
      redirect_to @user
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :username,
      	                           :password, :password_confirmation)
    end

end