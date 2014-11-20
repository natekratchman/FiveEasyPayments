class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.integer :venmo_uid
      t.integer :venmo_score
      t.float :payment_total_value
      t.integer :payment_total_time
      t.integer :last_transaction_id
      t.integer :transaction_count

      t.timestamps
    end
  end
end
