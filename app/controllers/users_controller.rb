class UsersController < ApplicationController

  def index
    @users = User.all
    render :json => @users#, :include => tasks
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    
    if @user.save    #TODO: CHANGE
      render :json => @user
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end

end