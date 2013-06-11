require 'spec_helper'

describe Account do
  let(:user) { FactoryGirl.create(:user) }

  before { @account = user.accounts.build(name: "Savings Account", slug: "savings") }

  subject { @account }

  it { should respond_to(:name) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should eq user }
  it { should respond_to(:transactions) }
  it { should respond_to(:slug) }

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

  describe "when slug is not present" do
    before { @account.slug = " " }
    it { should_not be_valid }
  end

  describe "when slug is too long" do
    before { @account.slug = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when slug format is invalid" do
    it "should be invalid" do
      slugs = %w[Savings&Checking my\ account]
      slugs.each do |invalid_slug|
        @account.slug = invalid_slug
        expect(@account).not_to be_valid
      end
    end
  end

  describe "when slug format is valid" do
    it "should be valid" do
      slugs = %w[account MY_ACCOUNT account123 my-account]
      slugs.each do |valid_slug|
        @account.slug = valid_slug
        expect(@account).to be_valid
      end
    end
  end

  describe "when slug is already taken" do
    before do
      account_with_same_slug = @account.dup
      account_with_same_slug.slug = @account.slug.upcase
      account_with_same_slug.save
    end

    it { should_not be_valid }
  end

  describe "account with mixed case" do
    let(:mixed_case_slug) { "AcCoUnT" }

    it "should be saved as all lower-case" do
      @account.slug = mixed_case_slug
      @account.save
      expect(@account.reload.slug).to eq mixed_case_slug.downcase
    end
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
