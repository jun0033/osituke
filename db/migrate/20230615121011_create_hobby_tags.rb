class CreateHobbyTags < ActiveRecord::Migration[6.1]
  def change
    create_table :hobby_tags do |t|
      t.references :hobby, null: false, foreign_key: true
      t.references :tag,   null: false, foreign_key: true

      t.timestamps
    end
  add_index :hobby_tags, [:hobby_id, :tag_id], unique: true
  end
end
