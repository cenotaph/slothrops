class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable

      # t.encryptable
      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable


      t.timestamps
    end
    add_column :users, :username, :string
    add_column :users, :real_name, :string
    add_column :users, :location, :string
    add_column :users, :website, :string
    add_column :users, :about_me, :text
    add_column :users, :twitter, :string
    add_column :users, :image, :string
    add_column :users, :slug, :string
    add_index :users, :email,                :unique => true
    add_index :users, :username, :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :slug, :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
    # add_index :users, :authentication_token, :unique => true
  end

  def self.down
    drop_table :users
  end
end
