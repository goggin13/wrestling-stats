class WrestleBet::Wrestler < ApplicationRecord
  belongs_to :college
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_fill: [100, 100]
  end

  after_commit :add_default_avatar, on: [:create, :update]

  private def add_default_avatar
    unless avatar.attached?
      file_name = "default_wrestler_avatar.jpg"
      default_avatar_path = Rails.root.join("app", "assets", "images", "wrestle_bet", file_name)
      self.avatar.attach(
        io: File.open(default_avatar_path),
        filename: file_name
      )
    end
  end
end
