require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_content('Sign in') }
    it { should have_title('Sign in') }
    it { should_not have_link('Profile') }
    it { should_not have_link('Settings') }
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_title(user.name) }
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Settings',    href: edit_user_path(user)) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
        it { should_not have_link('Profile') }
        it { should_not have_link('Settings') }
      end
    end
  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          sign_in user
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            expect(page).to have_title('Edit user')
          end

          describe "when signing in again" do
            before do
              delete signout_path
              visit signin_path
              sign_in user
            end

            it "should render the default (profile) page" do
              expect(page).to have_title(user.name) 
            end
          end
        end
      end

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com", username: "wrong") }
      before { sign_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_title(full_title('Edit user')) }
      end

      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Users controller" do
        before { sign_in user }

        describe "visiting the signup page" do
          before { visit signup_path }
        it { should_not have_title(full_title('Sign up')) }
        end

        describe "submitting to the create action" do
          before { post users_path }
          specify { expect(response).to redirect_to(root_path) }
        end
      end
    end

  end

  describe "user limit" do
    before do
      visit signup_path
      fill_in "Name",             with: "Example User"
      fill_in "Email",            with: "user@example.com"
      fill_in "Username",         with: "superuser"
      fill_in "Password",         with: "foobarbazqux"
      fill_in "Confirm Password", with: "foobarbazqux"
    end

    let(:submit) { "Create my account" }

    describe "for the first user" do
      describe "visiting the signup page" do
        it { should have_title(full_title('Sign up')) }
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end

    describe "for subsequent users" do
      before do
        click_button submit
      end

      describe "visiting the signup page" do
        before { get signup_path }
        specify { expect(response).to redirect_to(root_path) }
      end

      describe "submitting to the create action" do
        before { post users_path }
        specify { expect(response).to redirect_to(root_path) }
      end
    end

  end

end
