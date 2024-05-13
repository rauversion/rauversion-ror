class ApplicationMailer < ActionMailer::Base
  default from: ENV['EMAIL_ACCOUNT']
  layout "mailer"
end
