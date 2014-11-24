class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string    :name
      t.integer   :venmo_uid
      t.integer   :venmo_score
      t.bigint    :last_transaction_id
      t.integer   :settled_count
      t.float     :settled_value
      t.integer   :settled_time
      t.float     :settled_ratio
      t.integer   :pending_count
      t.float     :pending_value
      t.integer   :pending_time
      t.float     :pending_ratio
      t.integer   :uncharged_count
      t.float     :uncharged_value
      t.integer   :uncharged_time
      t.float     :uncharged_ratio

      t.timestamps
    end
  end
end
