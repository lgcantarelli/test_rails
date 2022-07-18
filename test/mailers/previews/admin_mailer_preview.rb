# test/mailers/previews/admin_mailer_preview.rb
class AdminMailerPreview < ActionMailer::Preview
  def update_email
  AdminMailer.with(Admin.first, Admin.last).update_email
  end
 end
 