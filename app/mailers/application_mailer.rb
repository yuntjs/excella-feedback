class ApplicationMailer < ActionMailer::Base
  default from: 'mailer@excella-feedback.herokuapp.com'
  layout 'mailer'
end
