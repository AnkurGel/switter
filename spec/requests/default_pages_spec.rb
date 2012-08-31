require 'spec_helper'

describe "DefaultPages" do
  subject { page }

  describe "Home page" do
    before { visit root_path }
    it { should have_selector('h1', :text => 'Switter') }
    it { should have_selector('title', :text => "Switter") }
    it { should_not have_selector('title', :text => "Home") }
  end

  describe "Help page" do
    before { visit help_path }
    it { should  have_selector('h1', :text => 'Help') }
    it { should have_selector('title', :text => "Help") }
  end

  describe "About page" do
    before { visit about_path }
    it { should have_selector('h1', :text => 'About Switter') }
    it { should have_selector('title', :text => "About") }
  end
end
