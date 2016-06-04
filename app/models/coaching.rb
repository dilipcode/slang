# == Schema Information
#
# Table name: coachings
#
#  id          :integer          not null, primary key
#  pupil_id    :integer
#  mentor_id   :integer
#  language_id :integer
#  accepted    :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Coaching < ActiveRecord::Base
  belongs_to :pupil, class_name: User.name
  belongs_to :mentor, class_name: User.name
  belongs_to :language
  attr_accessor :mentor_email

  after_create :send_coaching_invitation_email

  private
      def send_coaching_invitation_email
      return if self.mentor.skip_coaching_invitation_email        
       CoachingMailer.invite(self.mentor,self).deliver_now
      end
end
