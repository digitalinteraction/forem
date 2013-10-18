module Forem
  class SubscriptionMailer < ActionMailer::Base
    default :from => Forem.email_from_address

    def topic_reply(post_id, subscriber_id)
      # only pass id to make it easier to send emails using resque
      @post = Post.find(post_id)
      @user = Forem.user_class.find(subscriber_id)

      mail(:to => @user.email, :subject => I18n.t('forem.topic.received_reply'))
    end

    def topic_created(topic_id, subscriber_id)
      @topic = Topic.find(topic_id)
      @user = Forem.user_class.find(subscriber_id)

      mail(:to => @user.email, :subject => I18n.t('forem.topic.created_subject'))
    end
  end
end
