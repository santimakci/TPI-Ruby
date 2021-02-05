class UsersController < ApplicationController

  skip_before_action :authorized, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.create(params.require(:user).permit(:username, 
    :password))
    if @user.valid?
      session[:user_id] = @user.id
      redirect_to '/welcome'
    else
      redirect_to '/users/new', flash:{messages: "El usuario ya existe o se encuentra vacío" }
    end
  end

end
