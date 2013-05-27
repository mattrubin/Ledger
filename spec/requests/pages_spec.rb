require 'spec_helper'

describe "Static pages" do

  let(:base_title) { "Ledger" }

  describe "Home page" do
    before { visit root_path }

    it "should have the content 'Ledger'" do
      expect(page).to have_content('Ledger')
    end

    it "should have the base title" do
      expect(page).to have_title(base_title)
    end

    it "should not have a custom page title" do
      expect(page).not_to have_title('| Home')
    end
  end

  describe "Help page" do
    before { visit help_path }

    it "should have the content 'Help'" do
      expect(page).to have_content('Help')
    end

    it "should have the title 'Help'" do
      expect(page).to have_title("#{base_title} | Help")
    end
  end

  describe "About page" do
    before { visit about_path }

    it "should have the content 'About Ledger'" do
      expect(page).to have_content('About Ledger')
    end

    it "should have the title 'About'" do
      expect(page).to have_title("#{base_title} | About")
    end
  end

  describe "Contact page" do
    before { visit contact_path }

    it "should have the content 'Contact'" do
      expect(page).to have_content('Contact')
    end

    it "should have the title 'Contact'" do
      expect(page).to have_title("#{base_title} | Contact")
    end
  end
end
