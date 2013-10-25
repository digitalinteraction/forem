require 'friendly_id'

module Forem
  class Forum < ActiveRecord::Base
    include Forem::Concerns::Viewable

    extend FriendlyId
    friendly_id :name, :use => [:slugged, :finders]

    belongs_to :category

    has_many :topics,     :dependent => :destroy
    has_many :posts,      :through => :topics, :dependent => :destroy
    has_many :moderators, :through => :moderator_groups, :source => :group
    has_many :moderator_groups

    has_many :subscriptions, :class_name => "Forem::ForumSubscription"

    validates :category, :name, :description, :presence => true

    alias_attribute :title, :name

    # Fix for #339
    default_scope { order('name ASC') }

    def last_post_for(forem_user)
      if forem_user && (forem_user.forem_admin? || moderator?(forem_user))
        posts.last
      else
        last_visible_post(forem_user)
      end
    end

    def last_visible_post(forem_user)
      posts.approved_or_pending_review_for(forem_user).last
    end

    def moderator?(user)
      user && (user.forem_group_ids & moderator_ids).any?
    end

    def to_s
      name
    end

    def subscribe_user(subscriber_id, force=false)
      if subscriber_id && !(subscriptions.where(:subscriber_id => subscriber_id).any?)
        subscriptions.create!(:subscriber_id => subscriber_id)
      end
      subscriptions_for(subscriber_id).update_all(:active => true) if force
    end

    def unsubscribe_user(subscriber_id)
      subscriptions_for(subscriber_id).update_all(:active => false)
    end

    def subscriber?(subscriber_id)
      subscriptions_for(subscriber_id).any?
    end

    def subscriptions_for(subscriber_id)
      subscriptions.where(:subscriber_id => subscriber_id, :active => true)
    end

  end
end
