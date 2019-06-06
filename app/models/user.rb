# frozen_string_literal: true

class User < ApplicationRecord
  has_many :posts
  has_many :comments

  validates :name, presence: true, length: { maximum: 100 }
  validates :username, presence: true, length: { maximum: 30 }
end
