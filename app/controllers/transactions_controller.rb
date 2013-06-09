class TransactionsController < ApplicationController
  before_action :require_signed_in_user
  before_action :require_correct_user

  def new
    @transaction = @account.transactions.build
  end

  def create
    @transaction = @account.transactions.build(transaction_params)
    if @transaction.save
      flash[:success] = "Transaction created!"
      redirect_to @account
    else
      render 'new'
    end
  end

  private

    def transaction_params
      params.require(:transaction).permit(:description, :value, :moment)
    end

    def require_correct_user
      @account = Account.find(params[:account_id])
      redirect_to(root_path) unless current_user?(@account.user)
    end

end
