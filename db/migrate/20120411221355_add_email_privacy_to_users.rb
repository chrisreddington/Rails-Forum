class AddEmailPrivacyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_private, :boolean

  end
end
