class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string    :name
      t.integer   :venmo_uid
      t.integer   :venmo_score
      t.integer   :last_transaction_id
      t.integer   :settled_count
      t.float     :settled_charge_value
      t.integer   :settled_charge_time
      t.integer   :pending_count
      t.float     :pending_charge_value
      t.integer   :pending_charge_time
      t.integer   :uncharged_count
      t.float     :uncharged_value
      t.integer   :uncharged_time

      t.timestamps
    end
  end
end
