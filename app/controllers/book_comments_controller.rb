class BookCommentsController < ApplicationController
  
  def create
    @comment = BookComment.new(book_comment_params)
    @comment.user_id = current_user.id
    @comment.book_id = params[:book_id]
    unless @comment.save
      render 'error'
    end
      
    # *.js.erbで参照するインスタンス
    @book = Book.find(params[:book_id])
  end
  
  def destroy
    comment = BookComment.find(params[:id])
    comment.destroy
    
    # *.js.erbで参照するインスタンス
    @book = Book.find(params[:book_id])
  end
  
  private
  
  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
  
end
