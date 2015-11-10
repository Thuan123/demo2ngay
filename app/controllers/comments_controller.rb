class CommentsController < ApplicationController
 
  before_action :logged_in_user, only: [:create, :destroy, :get_micropost, :check_follow]
  before_action :correct_user,   only: :destroy
  before_action :get_micropost,  only: [:create, :check_follow]
  before_action :check_follow,  only: :create
  
  def index

  end


  def create
  	@comment = current_user.comments.create(comment_params)
  	@comment.micropost= Micropost.find(params[:micropost_id])
     if @comment.save
      flash[:success] = "Comment created!"
      @micropost= Micropost.find(params[:micropost_id])      
      redirect_to micropost_path(@micropost)

     else
      @comments=@microposts.comments.includes(:user)
      render 'microposts/show'     
    end
  end
 
  def destroy
  	@comment.destroy
    flash[:success] = "comment deleted"
    redirect_to request.referrer || root_url
  end
  private
  def comment_params
    params.require(:comment).permit(:content, :user_id, :micropost_id)
  end

    def correct_user
      @comment = current_user.comments.find_by(id: params[:id])
      redirect_to root_url if @comment.nil?
    end

    def get_micropost
    	 @microposts = Micropost.find(params[:micropost_id])
    end
    def check_follow
    	 if current_user!=@microposts.user
    	  if !current_user.following?(@microposts.user)
   	        flash[:danger] = "Please follow user before create comment"
   	        redirect_to :back
    	  end
    	end
    end

end
