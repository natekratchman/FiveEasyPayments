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

  def self.calculate_score(settled_value, pending_value, uncharged_count, settled_ratio, settled_count)
    
    settled_value_min   = User.minimum("settled_value")
    settled_value_max   = User.maximum("settled_value")
    pending_value_min   = User.minimum("pending_value")
    pending_value_max   = User.maximum("pending_value")
    uncharged_count_min = User.minimum("uncharged_count")
    uncharged_count_max = User.maximum("uncharged_count")
    settled_ratio_min   = User.minimum("settled_ratio")
    settled_ratio_max   = User.maximum("settled_ratio")
    settled_count_min   = User.minimum("settled_count")
    settled_count_max   = User.maximum("settled_count")

    settled_score       = eval(get_base_score("settled_value")) * 20
    pending_score       = ( 1 - eval(get_base_score("pending_value")) ) * 15
    uncharged_score     = eval(get_base_score("uncharged_count")) * 15
    payback_score       = eval(get_base_score("settled_ratio")) * 25
    transaction_score   = eval(get_base_score("settled_count")) * 20
    venmo_score = [settled_score, pending_score, uncharged_score, payback_score, transaction_score, 5].sum
  end

  def self.get_base_score(el)
    "(#{el} - #{el}_min) / (#{el}_max - #{el}_min)"
  end

end
