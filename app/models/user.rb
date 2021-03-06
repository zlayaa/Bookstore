class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  has_many :orders
  has_many :credit_cards
  has_many :addresses
  has_many :ratings

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.password_confirmation = user.password
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      user.skip_confirmation!
    end
  end

  def self.from_checkout_log_in(params)
    where(email: params[:user][:email]).first_or_create do |user|
      user.email = params[:user][:email]
      user.password = Devise.friendly_token[0,20]
      user.password_confirmation = user.password
    end
  end

  def current_order
     orders.find_or_create_by(state: 'cart')
  end
  end
