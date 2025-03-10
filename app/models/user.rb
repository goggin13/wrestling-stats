class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :wrestle_bet_bets, class_name: "WrestleBet::SpreadBet"

  def admin?
    email == "goggin13@gmail.com"
  end

  def display_name
    email.split("@")[0]
  end

  def wrestle_bet_score
    wrestle_bet_bets.all.count do |bet|
      bet.won?
    end
  end
end
