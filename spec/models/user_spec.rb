require 'spec_helper'

describe User do
  before { @user = User.new(name: 'Example user', email: 'user@example.com', password: 'foobar', password_confirmation: 'foobar' ) }
  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  it { should respond_to(:microposts) }

  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle(:admin)
    end
    it { should be_admin }
  end

  describe "when name is not present" do
    before { @user.name = ' ' }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = '' }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = ('a'..'z').to_a.shuffle.join * 2 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      %w(ankur@goel ankur@goel,com ankur@example. ankur@ankur_goel.com).each do |invalid|
        @user.email = invalid
        @user.should_not be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      %w(ankur@goel.com ANKUR@goel.com some_name@example.cn).each do |valid|
        @user.email = valid
        @user.should be_valid
      end
    end
  end

  describe "when email id is already taken" do
    before do
      user_with_same_email = @user.dup  #copies the user attributes
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save         #and saves itself
    end
    it { should_not be_valid }
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = '' }
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = 'mismatch' }
    it { should_not be_valid }
  end

  describe "with password that is too short" do
    before { @user.password = @user.password_confirmation = 'z' * 5; }
    it { should be_invalid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end
    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate('invalid_pass') }
      it { should_not == user_for_invalid_password }
    end
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "micropost association" do
    before { @user.save }
    let!(:older_micropost) { FactoryGirl.create(:micropost, :user => @user, :created_at => 1.day.ago) }
    let!(:newer_micropost) { FactoryGirl.create(:micropost, :user => @user, :created_at => 1.hour.ago) }

    it "should have the right microposts in right order" do
      @user.microposts.should == [newer_micropost, older_micropost]
    end

    it "should destroy associated microposts" do
      microposts = @user.microposts
      @user.destroy
      microposts.each { |m| Micropost.find_by_id(m.id).should be_nil }
    end
  end
end
