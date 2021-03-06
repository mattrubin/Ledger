require 'spec_helper'

describe User do

  before do
    @user = User.new(name: "Example User", email: "user@example.com", username: "thisismylongusername",
                     password: "foobarbazqux", password_confirmation: "foobarbazqux")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:username) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }

  it { should respond_to(:accounts) }

  it { should be_valid }

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when username is not present" do
    before { @user.username = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when username is too long" do
    before { @user.username = "a" * 21 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn a+b@sub.test-domain.com user@www.a9.com]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "when username format is invalid" do
    it "should be invalid" do
      usernames = %w[user@foo.com user\ name user-name]
      usernames.each do |invalid_username|
        @user.username = invalid_username
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when username format is valid" do
    it "should be valid" do
      usernames = %w[username USER_NAME username123 0user1name2]
      usernames.each do |valid_username|
        @user.username = valid_username
        expect(@user).to be_valid
      end
    end
  end

  describe "when username address is already taken" do
    before do
      user_with_same_username = @user.dup
      user_with_same_username.username = @user.username.upcase
      user_with_same_username.save
    end

    it { should_not be_valid }
  end

  describe "username with mixed case" do
    let(:mixed_case_username) { "UsErNaMe" }

    it "should be saved as all lower-case" do
      @user.username = mixed_case_username
      @user.save
      expect(@user.reload.username).to eq mixed_case_username.downcase
    end
  end

  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                       password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "when password confirmation is nil" do
    before do
      @user = User.new(name: "Michael Hartl", email: "mhartl@example.com",
                       password: "foobar", password_confirmation: nil)
    end
    it { should_not be_valid }
  end

  describe "when password confirmation is nil" do
    before do
      @user = User.new(name: "Michael Hartl", email: "mhartl@example.com",
                       password: "foobar", password_confirmation: nil)
    end
    it { should_not be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 9 }
    it { should be_invalid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "account associations" do

    before { @user.save }
    let!(:a_account) do
      FactoryGirl.create(:account, user: @user, name: "alpha", slug: "alpha", created_at: 1.day.ago)
    end
    let!(:z_account) do
      FactoryGirl.create(:account, user: @user, name: "Zeta", slug: "zeta", created_at: 1.hour.ago)
    end
    let!(:m_account) do
      FactoryGirl.create(:account, user: @user, name: "mu", slug: "mu", created_at: 1.minute.ago)
    end

    it "should have the right accounts in the right order" do
      expect(@user.accounts.to_a).to eq [a_account, m_account, z_account]
    end

    it "should destroy associated accounts" do
      accounts = @user.accounts.to_a
      @user.destroy
      expect(accounts).not_to be_empty
      accounts.each do |account|
        expect(Account.where(id: account.id)).to be_empty
      end
    end

  end
end
