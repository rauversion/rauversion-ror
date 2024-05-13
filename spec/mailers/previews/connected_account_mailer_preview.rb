# Preview all emails at http://localhost:3000/rails/mailers/connected_account_mailer
class ConnectedAccountMailerPreview < ActionMailer::Preview


  def new_account_notification_to_label
    connected_account = ConnectedAccount.last
    ConnectedAccountMailer.with(connected_account).new_account_notification_to_label(connected_account)
  end

  def invitation_email
    connected_account = ConnectedAccount.last
    ConnectedAccountMailer.with(connected_account).invitation_email(connected_account)
  end
end
