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

  describe "transaction associations" do

    before { @account.save }
    let!(:first_transaction) do
      FactoryGirl.create(:transaction, account: @account, description: "A", value: 22.22, moment: 2.hours.ago, created_at: 1.minute.ago)
    end
    let!(:second_transaction) do 
      FactoryGirl.create(:transaction, account: @account, description: "C", value: 33.33, moment: 2.days.ago, created_at: 1.hour.ago)
    end
    let!(:third_transaction) do 
      FactoryGirl.create(:transaction, account: @account, description: "B", value: 11.11, moment: 2.minutes.ago, created_at: 1.day.ago)
    end

    it "should have the right transactions in the right order" do
      expect(@account.transactions.to_a).to eq [third_transaction, first_transaction, second_transaction]
    end

    it "should destroy associated transactions" do
      transactions = @account.transactions.to_a
      @account.destroy
      expect(transactions).not_to be_empty
      transactions.each do |transaction|
        expect(Transaction.where(id: transaction.id)).to be_empty
      end
    end

  end

end
