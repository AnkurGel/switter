require 'spec_helper'

describe "UserPages" do
  before { visit signup_path }
  subject { page }

  it { should have_selector('h1', :text => "Sign up") }
  it { should have_selector('title', :text => 'Sign up') }

end
