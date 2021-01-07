# frozen_string_literal: true

class Ball < ApplicationRecord
  include AASM

  aasm :blue_ball, column: :blue_ball do # clinical ticket
    state :blue_ball_none, initial: true
    state :blue_patient, :blue_admin, :blue_provider

    event :provider_message_to_patient do
      transitions from: [:blue_ball_none, :blue_provider, :blue_admin], to: :blue_patient
    end

    event :provider_reassign, after_commit: :close_admin_chat! do
      transitions from: :blue_admin, to: :blue_provider
    end

    event :patient_response, after_commit: :admin_chat_started! do
      transitions from: :blue_patient, to: :blue_admin
    end

    event :resolve do
      transitions from: [:blue_provider, :blue_admin, :blue_patient, :blue_ball_none], to: :blue_ball_none
    end
  end

  aasm :red_ball, column: :red_ball do # non clinical ticket (between admin and patient)
    state :red_ball_none, initial: true
    state :red_patient, :red_admin

    event :admin_chat_started do
      transitions from: :red_ball_none, to: :red_admin
    end

    event :admin_replies_to_patient do
      transitions from: :red_admin, to: :red_patient
    end

    event :close_admin_chat do
      transitions from: :red_admin, to: :red_ball_none
    end
  end

  # didn't use this. don't know how things can be handled with state machine when
  # more than one patient response is required
  aasm :imaginary_ball, column: :imaginary_ball do
    state :none, initial: true
    state :patient, :admin
  end
end
