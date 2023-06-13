class CreateHobbies < ActiveRecord::Migration[6.1]
  def change
    create_table :hobbies do |t|
      t.integer :user_id,     null: false
      t.integer :tag_id,      null: false
      t.string :title,        null: false
      t.text :body,           null: false
      t.boolean :is_draft,    null: false, default: false
      t.timestamps
    end
  end
end