class User < ApplicationRecord
  # Remove :registerable if you don’t want open sign-ups
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  belongs_to :school, optional: true

  enum role: { public_user: 0, rto_user: 1, school_user: 2, admin: 3 }
end
