require 'spec_helper'

describe Transaction do
  let(:account) { FactoryGirl.create(:account) }

  before { @transaction = account.transactions.build(description: "Coffee", value: 11.11) }

  subject { @transaction }

  it { should respond_to(:description) }
  it { should respond_to(:value) }
  it { should respond_to(:account_id) }
  it { should respond_to(:account) }
  its(:account) { should eq account }

  it { should be_valid }

  describe "when account_id is not present" do
    before { @transaction.account_id = nil }
    it { should_not be_valid }
  end
end
