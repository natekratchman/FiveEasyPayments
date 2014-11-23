class Transaction

  def self.new_transaction?(payment_info, last_transaction_id)
    payment_info["data"].first["id"] != last_transaction_id
  end

  def self.increment_value(transaction, value)
    value += transaction["amount"]
  end

  def self.increment_time(transaction, time)
    created_date = Time.parse(transaction["date_created"])
    if !transaction["date_completed"]
      completed_date = Time.now
    else  
      completed_date = Time.parse(transaction["date_completed"])
    end
    time_to_payment = (completed_date - created_date)/60
    time += time_to_payment
  end

  def self.get_ratios(settled_value, pending_value, uncharged_value, settled_time, pending_time, uncharged_time)
    
    settled_ratio = self.calculate_ratio(settled_time, settled_value)
    pending_ratio = self.calculate_ratio(pending_time, pending_value)
    uncharged_ratio = self.calculate_ratio(uncharged_time, uncharged_value)
    ratios = {
      settled: settled_ratio,
      pending: pending_ratio,
      uncharged: uncharged_ratio
    }
  end 

  def self.calculate_ratio(time, value)
    if value == 0
      0
    else
      time/value
    end
  end

  def self.calculate_score(ratios, settled_count, pending_count, uncharged_count)
    base_score = 100
    total_count = [settled_count, pending_count, uncharged_count].sum
    total_count = 100 if total_count > 100

    venmo_score = base_score - total_count + ratios.values.sum
  end

end
