class User < ActiveRecord::Base

  def parse_info(payment_info)
    # if new transaction
      self.update_payment_totals(payment_info)
    # end
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

  def get_ratios(settled_value, pending_value, uncharged_value, settled_time, pending_time, uncharged_time)
    
    settled_ratio = calculate_ratio(settled_time, settled_value)
    pending_ratio = calculate_ratio(pending_time, pending_value)
    uncharged_ratio = calculate_ratio(uncharged_time, uncharged_value)
    ratios = {
      settled: settled_ratio,
      pending: pending_ratio,
      uncharged: uncharged_ratio
    }
  end 

  def calculate_ratio(time, value)
    if value == 0
      0
    else
      time/value
    end
  end

  def calculate_score(ratios, settled_count, pending_count, uncharged_count)
    total_count = [settled_count, pending_count, uncharged_count].sum
    venmo_score = ratios.values.sum/total_count
  end

  def update_payment_totals(payment_info)

    settled_value, pending_value, uncharged_value, settled_time, pending_time, uncharged_time, settled_count, pending_count, uncharged_count, last_transaction_id, i = Array.new(11){0}

    last_transaction_id = payment_info["data"].first["id"]
    
    # payment_info["data"].each do |transaction|
    #   if transaction["action"] == "charge" && transaction["actor"]["display_name"] != self.name
    #     if transaction["status"] == "settled" 
    #       settled_value = increment_value(transaction, settled_value)
    #       settled_time = increment_time(transaction, settled_time)
    #       settled_count += 1
    #     elsif transaction["status"] == "pending"
    #       pending_value = increment_value(transaction, pending_value)
    #       pending_time = increment_time(transaction, pending_time)
    #       pending_count += 1
    #     end
    #   elsif transaction["action"] == "pay" && transaction["actor"]["display_name"] == self.name
    #     uncharged_value = increment_value(transaction, uncharged_value)
    #     uncharged_time = increment_time(transaction, uncharged_time)
    #     uncharged_count += 1
    #    end
    # end
    
    transaction_type = {
      settled: 'transaction["action"] == "charge" && transaction["actor"]["display_name"] != self.name && transaction["status"] == "settled"',
      pending: 'transaction["action"] == "charge" && transaction["actor"]["display_name"] != self.name && transaction["status"] == "pending"',
      uncharged: 'transaction["action"] == "pay" && transaction["actor"]["display_name"] == self.name'
    }

    payment_info["data"].each do |transaction|
      if eval(transaction_type[:settled])
        settled_value = increment_value(transaction, settled_value)
        settled_time = increment_time(transaction, settled_time)
        settled_count += 1
      elsif eval(transaction_type[:pending])
        pending_value = increment_value(transaction, pending_value)
        pending_time = increment_time(transaction, pending_time)
        pending_count += 1
      elsif eval(transaction_type[:uncharged])
        uncharged_value = increment_value(transaction, uncharged_value)
        uncharged_time = increment_time(transaction, uncharged_time)
        uncharged_count += 1
      end
    end

    values = [settled_value, pending_value, uncharged_value]
    times = [settled_time, pending_time, uncharged_time]
    counts = [settled_count, pending_count, uncharged_count]

    ratios = self.get_ratios(*values, *times)
    venmo_score = self.calculate_score(ratios, *counts)

    self.update(
      settled_value: settled_value, 
      pending_value: pending_value, 
      uncharged_value: uncharged_value,  
      settled_time: settled_time, 
      pending_time: pending_time,
      uncharged_time: uncharged_time,  
      settled_count: settled_count,
      pending_count: pending_count,
      uncharged_count: uncharged_count,
      settled_ratio: ratios[:settled],
      pending_ratio: ratios[:pending],
      uncharged_ratio: ratios[:uncharged], 
      last_transaction_id: last_transaction_id, 
      venmo_score: venmo_score
    )

  end


  def self.login_or_create(auth_hash)
    find_by(venmo_uid: auth_hash.uid) || create(name: auth_hash.extra.raw_info.display_name, venmo_uid: auth_hash.uid)
  end

end
