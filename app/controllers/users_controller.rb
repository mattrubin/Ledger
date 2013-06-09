class UsersController < ApplicationController
  before_action :require_signed_in_user, only: [:edit, :update]
  before_action :require_correct_user,   only: [:edit, :update]
  before_action :require_new_user,       only: [:new, :create]
  before_action :require_first_user,     only: [:new, :create]

  def show
    @user = User.find_by_username!(params[:id])
    @accounts = @user.accounts.paginate(page: params[:page], per_page: 10)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Ledger!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end


  private

    def user_params
      params.require(:user).permit(:name, :email, :username,
      	                           :password, :password_confirmation)
    end

    # Before filters

    def require_correct_user
      @user = User.find_by_username!(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def require_new_user
      redirect_to root_path if signed_in?
    end

    def require_first_user
      redirect_to root_path if User.any?
    end

end
