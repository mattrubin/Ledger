require 'spec_helper'

describe Account do
  let(:user) { FactoryGirl.create(:user) }

  before { @account = user.accounts.build(name: "Savings Account") }

  subject { @account }

  it { should respond_to(:name) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should eq user }
  it { should respond_to(:transactions) }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @account.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank name" do
    before { @account.name = " " }
    it { should_not be_valid }
  end

  describe "with name that is too long" do
    before { @account.name = "a" * 101 }
    it { should_not be_valid }
  end
end
