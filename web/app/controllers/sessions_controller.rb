class SessionsController < ApplicationController

  skip_before_action :authorized, only: [:new, :create, :welcome]
  
  def new
  end
  
  def close
    reset_session
    redirect_to '/welcome'
  end

  def create
      @user = User.find_by(username: params[:username])
   if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to '/welcome'
   else
      redirect_to '/login', flash:{messages: "Usuario o contraseña incorrectos"}

    end
  end

  def login
  end

  def welcome
  end

  def page_requires_login
  end
end
