class CoachingsController < ApplicationController
  before_action :fetch_language
  def create
    @new_coaching = @language.coachings.new 
    mentor_email = params[:coaching][:mentor_email]
    if ValidateEmail.validate(mentor_email)      
      @mentor = User.where(email: mentor_email).first
      if @mentor.nil?
        # Send an invitation request to mentor to join the app

      elsif @mentor.teaching?(@language)
        flash.now[:danger] = I18n.t 'flash_messages.coachings.already_invited'
      else
        create_invitation
      end
    else
      @invalid_email = true
    end 
  end

private
    def fetch_language
      @language = Language.find(params[:language_id])
    end

    def create_invitation
      @new_coaching.pupil = current_user
      @new_coaching.mentor = @mentor 
      @new_coaching.save!
      flash.now[:success] = I18n.t 'flash_messages.coachings.invite_success'
    end
end
