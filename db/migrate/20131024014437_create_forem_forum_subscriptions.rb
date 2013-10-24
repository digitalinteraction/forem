class CreateForemForumSubscriptions < ActiveRecord::Migration
  def change
    create_table :forem_forum_subscriptions do |t|
      t.integer :subscriber_id
      t.integer :forum_id
      t.boolean :active, default: true
    end
  end
end
