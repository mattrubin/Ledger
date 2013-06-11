require 'spec_helper'

describe "Account pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "new account page" do
    before { visit new_account_path }

    it { should have_selector('h1', text: 'New Account') }
    it { should have_title(full_title('New Account')) }
  end

  describe "account creation" do
    before { visit new_account_path }

    describe "with invalid information" do

      it "should not create an account" do
        expect { click_button "Create" }.not_to change(Account, :count)
      end

      describe "error messages" do
        before { click_button "Create" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before do
        fill_in 'account_name', with: "Savings"
        fill_in 'account_slug', with: "savings"
      end

      it "should create an account for the current user" do
        expect { click_button "Create" }.to change(user.accounts, :count).by(1)
      end
    end
  end
end
