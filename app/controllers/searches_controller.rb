class SearchesController < ApplicationController
  
  def search
    @keyword = params[:keyword]
    target = params[:target]
    search = params[:search]
    obj = Object.const_get(target)
    
    if @keyword.present?
      if target == "User"
        @results = User.search_for(@keyword, search)
      elsif target == "Book"
        @results = Book.search_for(@keyword, search)
      else
        redirect_to request.referer
      end
    else
      @results = obj.none
    end
    
  end
end
