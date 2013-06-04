require 'spec_helper'

describe Account do
  let(:user) { FactoryGirl.create(:user) }

  before do
    # This code is not idiomatically correct.
    @account = Account.new(name: "Savings Account", user_id: user.id)
  end

  subject { @account }

  it { should respond_to(:name) }
  it { should respond_to(:user_id) }
end
