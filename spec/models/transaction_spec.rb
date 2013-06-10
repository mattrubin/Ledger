require 'spec_helper'

describe Transaction do
  let(:account) { FactoryGirl.create(:account) }

  before { @transaction = account.transactions.build(description: "Coffee", value: 11.11, moment: 1.day.ago) }

  subject { @transaction }

  it { should respond_to(:description) }
  it { should respond_to(:value) }
  it { should respond_to(:moment) }
  it { should respond_to(:account_id) }
  it { should respond_to(:account) }
  its(:account) { should eq account }

  it { should be_valid }

  describe "when account_id is not present" do
    before { @transaction.account_id = nil }
    it { should_not be_valid }
  end

  describe "when moment is not present" do
    before { @transaction.moment = nil }
    it { should_not be_valid }
  end

  describe "with empty value" do
    before { @transaction.value = nil }
    it { should_not be_valid }
  end

  describe "with blank description" do
    before { @transaction.description = " " }
    it { should_not be_valid }
  end

  describe "with description that is too long" do
    before { @transaction.description = "a" * 101 }
    it { should_not be_valid }
  end
end
