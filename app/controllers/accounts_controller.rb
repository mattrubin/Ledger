class AccountsController < ApplicationController
  before_action :require_signed_in_user
  before_action :require_correct_user, only: [:show, :edit, :update, :destroy]

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
    @transactions = @account.transactions.paginate(page: params[:page])
  end

  def edit
  end

  def update
    if @account.update_attributes(account_params)
      flash[:success] = "Account updated"
      redirect_to @account
    else
      render 'edit'
    end
  end

  def destroy
  end

  private

    def account_params
      params.require(:account).permit(:name, :slug)
    end

    def require_correct_user
      @account = Account.find_by_slug!(params[:id])
      redirect_to(root_path) unless current_user?(@account.user)
    end

end
