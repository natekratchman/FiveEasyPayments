class User < ActiveRecord::Base

  def parse_info(payment_info)
    self.update_payment_totals(payment_info)
  end

  def update_payment_totals(payment_info)
    settled_charge_value, pending_charge_value, uncharged_value, settled_charge_time, pending_charge_time, uncharged_time, settled_count, pending_count, uncharged_count, last_transaction_id, i = Array.new(11){0}

    last_transaction_id = payment_info["data"].first["id"]
    payment_info["data"].each do |transaction|

      if transaction["action"] == "charge" && transaction["actor"]["display_name"] != self.name
        if transaction["status"] == "settled" 
          settled_charge_value = increment_value(transaction, settled_charge_value)
          settled_charge_time = increment_time(transaction, settled_charge_time)
          settled_count += 1
        elsif transaction["status"] == "pending"
          pending_charge_value = increment_value(transaction, pending_charge_value)
          pending_charge_time = increment_time(transaction, pending_charge_time)
          pending_count += 1
        end
      elsif transaction["action"] == "pay" && transaction["actor"]["display_name"] == self.name
        uncharged_value = increment_value(transaction, uncharged_value)
        uncharged_time = increment_time(transaction, uncharged_time)
        uncharged_count += 1
       end
    end

    venmo_score = self.calculate_score(settled_charge_value, settled_charge_time)

    self.update(settled_charge_value: settled_charge_value, 
                pending_charge_value: pending_charge_value, 
                uncharged_value: uncharged_value,  
                settled_charge_time: settled_charge_time, 
                pending_charge_time: pending_charge_time,
                uncharged_time: uncharged_time,  
                settled_count: settled_count,
                pending_count: pending_count,
                uncharged_count: uncharged_count,
                last_transaction_id: last_transaction_id, 
                venmo_score: venmo_score)
  end

  def increment_value(transaction, value)
    value += transaction["amount"]
  end

  def increment_time(transaction, time)
    created_date = Time.parse(transaction["date_created"])
    if !transaction["date_completed"]
      completed_date = Time.now
    else  
      completed_date = Time.parse(transaction["date_completed"])
    end
    time_to_payment = (completed_date - created_date)/60
    time += time_to_payment
  end

  def calculate_score(settled_charge_value, settled_charge_time)
    (settled_charge_time/settled_charge_value).round(2)
  end

  def self.login_or_create(auth_hash)
    find_by(venmo_uid: auth_hash.uid) || create(name: auth_hash.extra.raw_info.display_name, venmo_uid: auth_hash.uid)
  end

end
