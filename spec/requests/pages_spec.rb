require 'spec_helper'

describe "Static pages" do

  let(:base_title) { "Ledger" }

  describe "Home page" do
  before { visit '/pages/home' }

    it "should have the content 'Ledger'" do
      expect(page).to have_content('Ledger')
    end

    it "should have the title 'Home'" do
      expect(page).to have_title("#{base_title} | Home")
    end
  end

  describe "Help page" do
    before { visit '/pages/help' }

    it "should have the content 'Help'" do
      expect(page).to have_content('Help')
    end

    it "should have the title 'Help'" do
      expect(page).to have_title("#{base_title} | Help")
    end
  end

  describe "About page" do
    before { visit '/pages/about' }

    it "should have the content 'About Ledger'" do
      expect(page).to have_content('About Ledger')
    end

    it "should have the title 'About Us'" do
      expect(page).to have_title("#{base_title} | About Us")
    end
  end

  describe "Contact page" do
    before { visit '/pages/contact' }

    it "should have the content 'Contact'" do
      expect(page).to have_content('Contact')
    end

    it "should have the title 'Contact'" do
      expect(page).to have_title("#{base_title} | Contact")
    end
  end
end
