require 'spec_helper'

describe "Static pages" do

  describe "Home page" do

    it "should have the content 'Ledger'" do
      visit '/pages/home'
      expect(page).to have_content('Ledger')
    end
  end

  describe "Help page" do

    it "should have the content 'Help'" do
      visit '/pages/help'
      expect(page).to have_content('Help')
    end
  end

  describe "About page" do

    it "should have the content 'About Ledger'" do
      visit '/pages/about'
      expect(page).to have_content('About Ledger')
    end
  end
end
