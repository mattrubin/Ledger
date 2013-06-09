class AccountsController < ApplicationController
  before_action :require_signed_in_user

  def index
  end

  def new
	@account = current_user.accounts.build
  end

  def create
    @account = current_user.accounts.build(account_params)
    if @account.save
      flash[:success] = "Account created!"
      redirect_to current_user
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

    def account_params
      params.require(:account).permit(:name)
    end
end
