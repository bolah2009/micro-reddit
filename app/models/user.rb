class User < ApplicationRecord
    validates :name, presence: true, length: { maximum: 100 }
    validates :username, presence: true, length: { maximum: 30 }
    has_many :posts
end
