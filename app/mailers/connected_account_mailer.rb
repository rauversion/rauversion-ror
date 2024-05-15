class ConnectedAccountMailer < ApplicationMailer
  # default from: 'noreply@labelx.com'

  # Method to send an invitation confirmation email to existing artists
  def invitation_email(connected_account)
    @artist = connected_account.user
    @label = connected_account.parent
    @connected_account = connected_account
    mail(to: @artist.email, subject: "Welcome to Join Us at Label #{@label.username} on Rauversion.com!")
  end

  # Method to notify the label of a new artist account creation
  def new_account_notification_to_label(connected_account)
    @artist = connected_account.user
    @label = connected_account.parent
    mail(to: @label.email, subject: "New Artist Account Activation at Label #{@label.username}!")
  end

  def new_account_notification_to_artist(connected_account)
    @artist = connected_account.user
    @label = connected_account.parent
    mail(to: @label.email, subject: "New Artist Account Activation at Label #{@label.username}!")
  end
end
