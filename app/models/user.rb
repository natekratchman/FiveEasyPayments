class User < ActiveRecord::Base

  def parse_info(payment_info)
    self.update_payment_totals(payment_info)
  end

  def update_payment_totals(payment_info)
    settled_charge_value, settled_charge_time, transaction_count, last_transaction_id, i = Array.new(5){0}

    payment_info["data"].each do |transaction|
      if transaction["status"] == "settled" && transaction["action"] == "charge" && transaction["actor"]["display_name"] != self.name

        settled_charge_value = increment_settled_charge_value(transaction, settled_charge_value)
        settled_charge_time = increment_settled_charge_time(transaction, settled_charge_time)
    
        if i == 0
          last_transaction_id = transaction["id"]
          i = 1
        end

        transaction_count += 1
      # elsif transaction["status"] == "pending"
      #   find_pending
       end
    end

    venmo_score = self.calculate_score(settled_charge_value, settled_charge_time)
    self.update(settled_charge_value: settled_charge_value, settled_charge_time: settled_charge_time, last_transaction_id: last_transaction_id, venmo_score: venmo_score, transaction_count: transaction_count)
  end

  def increment_settled_charge_value(transaction, settled_charge_value)
    settled_charge_value += transaction["amount"]
  end

  def increment_settled_charge_time(transaction, settled_charge_time)
    t1 = Time.parse(transaction["date_created"])
    t2 = Time.parse(transaction["date_completed"])
    time_to_payment = (t2 - t1)/60
    settled_charge_time += time_to_payment
  end

  def find_pending
    #return total value of pending payments
    #return total time for those payments
  end

  def calculate_score(settled_charge_value, settled_charge_time)
    (settled_charge_time/settled_charge_value).round(2)
  end

  def self.login_or_create(auth_hash)
    find_by(venmo_uid: auth_hash.uid) || create(name: auth_hash.extra.raw_info.display_name, venmo_uid: auth_hash.uid)
  end

end
