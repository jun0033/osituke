class CreateHobbyComments < ActiveRecord::Migration[6.1]
  def change
    create_table :hobby_comments do |t|
      t.integer :hobby_id,    null: false
      t.integer :user_id,     null: false
      t.text :comment,        null: false
      t.string :star,

      t.timestamps
    end
  end
end
