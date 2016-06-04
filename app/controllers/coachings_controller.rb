class CoachingsController < ApplicationController
  before_action :fetch_language
  before_action :fetch_coaching, only: [:update, :destroy]
  def create
    @new_coaching = @language.coachings.new 
    mentor_email = params[:coaching][:mentor_email]
    if ValidateEmail.validate(mentor_email) && mentor_email != current_user.email   
      @mentor = User.where(email: mentor_email).first
      if @mentor.nil?
        # Send an invitation request to mentor to join the app
        @mentor = User.invite!({email: mentor_email}, current_user) do |usr|
          usr.invited_language = @language
        end
        @mentor.skip_coaching_invitation_email = true
        create_invitation
      elsif @mentor.teaching?(@language,current_user)
        flash.now[:danger] = I18n.t 'flash_messages.coachings.already_invited'
      else
        create_invitation
      end
    else
      @invalid_email = true
    end 
  end

  def update
    @coaching.update_attribute(:accepted, true)
    flash[:success] = I18n.t 'flash_messages.coachings.accepted_success'
    redirect_to root_path
  end

  def destroy
    @coaching.destroy
    redirect_to root_path
  end

private
    def fetch_language
      @language = Language.find(params[:language_id])
    end

    def fetch_coaching
      @coaching= @language.coachings.find(params[:id])

    end

    def create_invitation
      @new_coaching.pupil = current_user
      @new_coaching.mentor = @mentor
      @new_coaching.save!
      flash.now[:success] = I18n.t 'flash_messages.coachings.invite_success'
    end
end
