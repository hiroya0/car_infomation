# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.username = 'ゲストさん'
    end
  end

  validates :username, presence: true

  has_many :articles, through: :bookmarks
  has_many :bookmarks, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :keywords, dependent: :destroy
end
