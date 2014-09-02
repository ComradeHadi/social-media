class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :token
      t.string :salted_password
      t.datetime :created_on
      t.datetime :signed_in_on

      t.timestamps
    end
  end
end