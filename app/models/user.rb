class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :wrestle_bet_bets, class_name: "WrestleBet::SpreadBet"

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end

  after_commit :add_default_avatar, on: [:create, :update]

  def admin?
    email == "goggin13@gmail.com"
  end

  def display_name
    email.split("@")[0]
  end

  def encoded_email
    Base64.encode64(email).chomp
  end

  private def add_default_avatar
    return if Rails.env.test?

    unless avatar.attached?
      file_name = "default_user_avatar.png"
      default_avatar_path = Rails.root.join("app", "assets", "images", file_name)
      self.avatar.attach(
        io: File.open(default_avatar_path),
        filename: file_name
      )
    end
  end
end
