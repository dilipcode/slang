# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string
#  date_of_birth          :datetime
#  is_female              :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
   
  has_many :languages
  # has_many :accepted_pupil_coachings, -> { where(accepted: true)}, foreign_key: :pupil_id,class_name: Coaching.name
  # has_many :pending_pupil_coachings, ->{ where(accepted: false)}, foreign_key: :pupil_id, class_name: Coaching.name 

  # has_many :accepted_mentor_coachings, ->{ where(accepted: true)}, foreign_key: :mentor_id, class_name: Coaching.name
  has_many :pending_mentor_coachings, ->{ where(accepted: false)}, foreign_key: :mentor_id, class_name: Coaching.name
  
  attr_accessor :invited_language, :skip_coaching_invitation_email
  def teaching?(lang,user)
    Coaching.where(language: lang, mentor: self.id, pupil: user).any?
  end
end
