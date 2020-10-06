class User < ApplicationRecord
  #保存される前に実行されるアクション
  before_save { self.email = email.downcase! }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  #存在チェック,文字数チェック
  validates :name, presence: true, length:{maximum: 50}
  validates :email,presence: true, length:{maximum: 255},
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :password, presence: true, length:{minimum: 6}
  
  has_secure_password
end
