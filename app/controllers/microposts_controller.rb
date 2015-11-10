class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  def index
    @microposts = Micropost.paginate(page: params[:page])
  end  
  def create
  	@micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      #redirect_to root_url
      redirect_to static_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def show
    @microposts = Micropost.find(params[:id])
    @comment = @microposts.comments.build
    @comments=@microposts.comments.includes(:user)
  end

  def destroy
  	@micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end
  
  private

    def micropost_params
     params.require(:micropost).permit(:content, :picture, :title)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
