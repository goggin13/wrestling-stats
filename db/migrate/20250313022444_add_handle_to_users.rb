class AddHandleToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :handle, :string
  end
end
