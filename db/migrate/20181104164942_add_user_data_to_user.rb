class AddUserDataToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :role, :integer, default: 0
    add_column :users, :jti, :string, null: false, index: {unique: true}
    add_reference :users, :company, foreign_key: true
  end
end
