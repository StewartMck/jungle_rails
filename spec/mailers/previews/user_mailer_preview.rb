# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/receipt_email
  def receipt_email

    UserMailer.receipt_email(Order.last)

  end

end
