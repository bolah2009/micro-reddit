# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_many :comments

  validates :title, presence: true, length: { maximum: 126 }, uniqueness: true
  validates :body, presence: true, length: { maximum: 2000 }
end
