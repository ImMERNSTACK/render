class User < ApplicationRecord
  has_many :expenses
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  after_create :schedule_welcome_email
  
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }

  private
  
  def schedule_welcome_email
    SendWelcomeEmailJob.set(wait: 1.hour).perform_later(self)
  end
end
