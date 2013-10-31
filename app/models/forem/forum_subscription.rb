module Forem
  class ForumSubscription < ActiveRecord::Base
    belongs_to :forum
    belongs_to :subscriber, :class_name => Forem.user_class.to_s

    validates :subscriber_id, :presence => true

    def send_notification(topic_id)
      # If a user cannot be found, then no-op
      # This will happen if the user record has been deleted.
      if subscriber.present?
        SubscriptionMailer.topic_created(topic_id, subscriber.id).deliver
      end
    end

  end
end
