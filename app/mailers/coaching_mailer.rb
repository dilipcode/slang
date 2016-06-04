class CoachingMailer < ApplicationMailer
  def invite(user, coaching)
    @user = user
    @coaching = coaching 
    @url  = root_url
    mail(:to => @user.email, :subject => "Invitation to teach")
  end
end
