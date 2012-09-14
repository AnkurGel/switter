require 'spec_helper'

describe "UserPages" do
  before { visit signup_path }
  subject { page }

  it { should have_selector('h1',       :text => "Sign up") }
  it { should have_selector('title',    :text => 'Sign up') }

  describe "index" do
    before do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, :name => 'foo', :email => 'foo@bar.com')
      FactoryGirl.create(:user, :name => 'Amita', :email => 'amita@pradhan.com')
      visit users_path
    end

    it { should have_selector('title', :text => 'All users') }
    it { should have_selector('h1', :text => 'All users') }

    it "should list all user" do
      User.all.each{ |usr| page.should have_selector('li', :text => usr.name) }
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    let!(:m1) { FactoryGirl.create(:micropost, :user => user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, :user => user, content: "Bar") }

    it { should have_selector('h1',     :text => user.name) }
    it { should have_selector('title',  :text => user.name) }
  end

  describe "microposts" do
    it { should have_content(m1.content) }
    it { should have_content(m2.content) }
    it { should have_content(user.microposts.count) }
  end

  describe "signup" do

    before { visit signup_path }
    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",       :with => "Ankur Goel"
        fill_in "Email",      :with => "ankurgel@gmail.com"
        fill_in "Password",   :with => "foobar"
        fill_in "Confirmation", :with => "foobar"
      end
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end

  describe 'edit page' do
    let(:user) { FactoryGirl.create(:user) }
    before { sign_in user; visit edit_user_path(user) }

    describe "page" do
      it { should have_selector('h1', :text => 'Update your profile') }
      it { should have_selector('title', :text => 'Edit user') }
      it { should have_link('change', :href => 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button 'Save changes' }
      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name) { "Foo Bar" }
      let(:new_email) { "foo_bar@gmail.com" }
      before do
        fill_in "Name", :with => new_name
        fill_in "Email", :with => new_email
        fill_in "Password", :with => user.password
        fill_in "Confirm Password", :with => user.password
        click_button 'Save changes'
      end
      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end
  end

  describe "delete links" do
    it { should_not have_link('delete') }

    describe "as an admin user" do
      let(:admin) { FactoryGirl.create(:admin) }
      before { sign_in admin; visit users_path }
      it "should not have ability to delete himself" do
        should_not have_link('delete', :href => user_path(admin))
      end
    end
  end

end
