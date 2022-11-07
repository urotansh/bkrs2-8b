class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  # userとrelationshipsが1:Nの関係
  has_many :relationships, class_name: "Relationship",
                           foreign_key: "follower_id",
                           dependent: :destroy
  
  # userとreverse_relationshipsが1:Nの関係
  has_many :reverse_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  
  # user->relationshipsテーブルを経由してfollowed(user)テーブル参照
  has_many :followings, through: :relationships, source: :followed
  
  # user->reverse_relationshipsテーブルを経由してfollower(user)テーブル参照
  has_many :followers, through: :reverse_relationships, source: :follower
  
  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true

  validates :introduction, length: { maximum: 50 }
  
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
  
  def followed_by?(user)
    followers.exists?(id: user.id)
  end
  
  def self.search_for(keyword, search)
    
    #検索カラム
    column = "name"
    
    # 完全一致検索
    if search == "perfect_match"
      User.where("#{column}": keyword)
    # 前方一致検索
    elsif search == "forward_match"
      User.where("#{column} LIKE ?", "#{keyword}%")
    # 後方一致検索
    elsif search == "backward_match"
      User.where("#{column} LIKE ?", "%#{keyword}")
    # 部分一致検索
    elsif search == "partial_match"
      User.where("#{column} LIKE ?", "%#{keyword}%")
    # それ以外
    else
      User.none
    end
  end
  
end
