class UsersController < ApplicationController

  include ActionController::Cookies

  def index
    @users = User.all
    render :json => @users, :only => [:first_name, :last_name, :email]
  end

  def show
    @user = User.find(params[:id])
    render_user
  end

  def create
    @user = User.new(user_params)
    puts @user.inspect
    
    if @user.save
      render_user
    else
      # todo - add validation error handling
      render json: @user.errors.full_messages, status: 400
    end
  end

  def update
    @user = User.find(params[:id])
    if @user && @user.token == cookies[:token]
      if @user.update(user_params)
        render_user
      else
        #todo: update failed
      end
    else
      #todo: failed auth - invalid session token
    end
  end

  
  def sign_in
    # todo: add email & password format validation

    @user = User.find_by email: params[:email]
    puts params.inspect
    
    if @user && @user.password == params[:password]
      token = SecureRandom.base64
      @user.token = token
      @user.save

      if @user.valid?
        puts "token: " + token
        cookies[:token] = token 
        puts "cookie: " + cookies[:token]   
        render_user    
      end
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
    render :json => @user, :only => [:first_name, :last_name, :email]
  end

end