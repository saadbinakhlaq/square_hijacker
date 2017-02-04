class User < ApplicationRecord
  include Clearance::User

  include Clearance::User

  has_many :players, dependent: :destroy
  has_many :games, through: :players

  validates :email,
          presence: true,
        uniqueness: true,
            format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i },
                on: :create
end
