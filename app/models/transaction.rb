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

  def self.calculate_score(settled_value, pending_value, uncharged_count, settled_ratio, user_settled_count)
    settled_score = ((settled_value-User.minimum("settled_value"))/(User.maximum("settled_value")-User.minimum("settled_value")))* 20
    pending_score = (1-(pending_value-User.minimum("pending_value")/(User.maximum("pending_value")-User.minimum("pending_value"))))* 15
    uncharged_score = (uncharged_count-User.minimum("uncharged_count").to_f/(User.maximum("uncharged_count")-User.minimum("uncharged_count")))*15
    payback_score = ((settled_ratio-User.minimum("settled_ratio"))/(User.maximum("settled_ratio")-User.minimum("settled_ratio")))* 25
    transaction_score = ((user_settled_count-User.minimum("settled_count")).to_f/(User.maximum("settled_count")-User.minimum("settled_count")))* 20
    venmo_score = settled_score + pending_score + uncharged_score + payback_score + transaction_score + 5
  end

end
