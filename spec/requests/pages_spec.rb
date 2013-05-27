require 'spec_helper'

describe "Static pages" do

  describe "Home page" do

    it "should have the content 'Ledger'" do
      visit '/pages/home'
      expect(page).to have_content('Ledger')
    end

    it "should have the title 'Home'" do
      visit '/pages/home'
      expect(page).to have_title("Ledger | Home")
    end
  end

  describe "Help page" do

    it "should have the content 'Help'" do
      visit '/pages/help'
      expect(page).to have_content('Help')
    end

    it "should have the title 'Help'" do
      visit '/pages/help'
      expect(page).to have_title("Ledger | Help")
    end
  end

  describe "About page" do

    it "should have the content 'About Ledger'" do
      visit '/pages/about'
      expect(page).to have_content('About Ledger')
    end

    it "should have the title 'About Us'" do
      visit '/pages/about'
      expect(page).to have_title("Ledger | About Us")
    end
  end

  describe "Contact page" do

    it "should have the content 'Contact'" do
      visit '/pages/contact'
      expect(page).to have_content('Contact')
    end

    it "should have the title 'Contact'" do
      visit '/pages/contact'
      expect(page).to have_title("Ledger | Contact")
    end
  end
end
