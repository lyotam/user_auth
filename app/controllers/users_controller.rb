class UsersController < ApplicationController

  include ActionController::Cookies

  before_action :validate_user_auth, only: [:show, :update]

  def index
    @users = User.all
    render :json => @users, :only => [:first_name, :last_name, :email]
  end

  def show
    render_user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render_user
    else
      bad_request_error
    end
  end

  def update
    if @user.update(user_params)
      render_user
    else
      bad_request_error
    end
  end

  
  def sign_in
    @user = User.find_by email: params[:email]
    
    if @user && @user.password == params[:password]
      token = SecureRandom.base64
      @user.token = token
      @user.save
      cookies[:token] = token 
      render_user    
    else
      not_authorized_error("wrong credentials")
    end
  end

  def sign_out
    token = cookies[:token]
    if token
      cookies.delete(:token)
    end
  end

  private

  def user_params
    params.require(:user)
    .permit(:first_name, :last_name, :email, :password, :token)
  end

  def render_user
    render :json => @user, :only => [:id, :first_name, :last_name, :email]
  end  

  def bad_request_error
    render json: {"#{'error'.pluralize(@user.errors.count)}": 
                  @user.errors.full_messages}, 
                  status: 400
  end

  def not_authorized_error(message)
    render json: {"error": message}, status: 401
  end

  def validate_user_auth
    @user = User.find(params[:id])
    unless @user && @user.token == cookies[:token]
      not_authorized_error("Not authorized to access this user")
    end
  end

end