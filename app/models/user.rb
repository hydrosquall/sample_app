# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean         default(FALSE)
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation  #note admin attribute not mass-assignable, 
  has_secure_password

  has_many :microposts, dependent: :destroy #posts go when users go
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed  # assembles array using followed_id in the relationships table.

  #clever table reversal. Note explicit definition of class, otherwise it would look for "ReverseRelationships" class
  has_many :reverse_relationships,  foreign_key: "followed_id",     
                                    class_name: "Relationship",
                                    dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower #technically can ignore third param because rails will seek followed_id automatically given "followers"


  #before_save{ |user| user.email = email.downcase }
  # alternate one line way of casing email
  before_save { self.email.downcase! }
  #sessions authentication
  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
  					format: {with: VALID_EMAIL_REGEX}, 
  					uniqueness: {case_sensitive: false}
  					
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence:true

  def feed
  	# preliminary implementation. The #id gets escaped to prevent SQL injection. this is technically equivalent to writing 
  	# microposts
  	Micropost.where("user_id = ?", id)

  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id) #note that presence of "self" is implied, it's a stylistic choice
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  private

  	def create_remember_token
  		self.remember_token = SecureRandom.urlsafe_base64
  	end
end
