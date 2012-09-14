class SessionsController < ApplicationController
  #new to create session, create to act on new call, destroy to logout.
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user and user.authenticate(params[:session][:password])
      #if successfully gets authenticated, then
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    sign_out #defined in session_helper.rb; removes the remember token from sessio
    redirect_to root_path
  end
end
