class ApplicationJob < ActiveJob::Base
  def max_attempts
    1
  end
  def destroy_failed_jobs?
    true
  end
end
