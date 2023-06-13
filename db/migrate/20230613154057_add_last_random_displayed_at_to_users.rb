class AddLastRandomDisplayedAtToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :last_random_displayed_at, :datetime
  end
end
