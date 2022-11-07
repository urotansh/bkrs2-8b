class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update, :edit]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    
    @user_today_books_size = @user.today_books.size
    @user_yesterday_books_size = @user.yesterday_books.size
    @dod = @user_today_books_size / @user_yesterday_books_size.to_f * 100
    
    @user_this_week_books_size = @user.this_week_books.size
    @user_last_week_books_size = @user.last_week_books.size
    @wow = @user_this_week_books_size / @user_last_week_books_size.to_f * 100
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
