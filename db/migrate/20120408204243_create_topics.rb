class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :name
      t.integer :user_id
      t.datetime :last_post_at
      t.integer :board_id

      t.timestamps
    end
  end
end
