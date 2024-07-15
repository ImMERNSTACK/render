# app/jobs/send_welcome_email_job.rb

class SendWelcomeEmailJob < ApplicationJob
  queue_as :default

  before_perform :log_job_start
  after_perform :log_job_success
  rescue_from(StandardError) do |exception|
    log_job_failure(exception)
  end

  def perform(user)
    UserMailer.welcome_email(user).deliver_now
  end

  private

  def log_job_start
    Rails.logger.info "Job #{self.job_id} started at #{Time.current}"
  end

  def log_job_success
    Rails.logger.info "Job #{self.job_id} completed successfully at #{Time.current}"
  end

  def log_job_failure(exception)
    Rails.logger.error "Job #{self.job_id} failed with error: #{exception.message}"
  end
end
