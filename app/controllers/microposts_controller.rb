class MicropostsController < ApplicationController
  before_filter :signed_in_user, :only => [:create, :destroy]

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      # in case unsuccessful, populate with preexisting posts
      @feed_items = current_user.feed.paginate(:page => params[:page])
      render 'default_pages/home'
    end
  end

  def destroy
    @micropost = current_user.microposts.find_by_id(params[:id])
    if @micropost.nil?
      redirect_to root_url
    else
      @micropost.destroy
      redirect_to root_url
    end
  end
end

