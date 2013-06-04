require 'spec_helper'

describe Account do
  let(:user) { FactoryGirl.create(:user) }

  before { @account = user.accounts.build(name: "Savings Account") }

  subject { @account }

  it { should respond_to(:name) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @account.user_id = nil }
    it { should_not be_valid }
  end
end
