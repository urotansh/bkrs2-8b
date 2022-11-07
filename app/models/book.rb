class Book < ApplicationRecord

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.search_for(keyword, search)
    
    #検索カラム
    column = "title"
    
    # 完全一致検索
    if search == "perfect_match"
      Book.where("#{column}": keyword)
    # 前方一致検索
    elsif search == "forward_match"
      Book.where("#{column} LIKE ?", "#{keyword}%")
    # 後方一致検索
    elsif search == "backward_match"
      Book.where("#{column} LIKE ?", "%#{keyword}")
    # 部分一致検索
    elsif search == "partial_match"
      Book.where("#{column} LIKE ?", "%#{keyword}%")
    # それ以外
    else
      Book.none
    end
  end
  
end
