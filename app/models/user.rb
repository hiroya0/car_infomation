# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true

  has_many :articles, through: :bookmarks
  has_many :bookmarks, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :keywords
end
