class Micropost < ApplicationController
  before_filter :signed_in_user :only => [:create, :destroy]

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      render 'default_pages/home'
    end
  end

  def destroy
  end

end

