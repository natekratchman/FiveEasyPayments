class User < ActiveRecord::Base

  def self.call_lucas
    ### PRODUCTION - waiting on venmo gosh darnit!
    # JSON.parse(open("https://api.venmo.com/v1/payments?access_token=#{session[:token]}&limit=1000").read)

    ### TESTING
    # JSON.parse(IO.read("app/test_data/kana_data.json"))
    # JSON.parse(IO.read("app/test_data/ben_data.json"))
    JSON.parse(IO.read("app/test_data/nate_data.json"))
  end

  def parse_info(payment_info)
    self.update_payment_totals(payment_info) #if Transaction.new_transaction?(payment_info, self.last_transaction_id)
    # note: should put new_transaction? back in place, once PaymentHash.add_to_payment_json (below) has been abstracted out of User model
  end

  def update_payment_totals(payment_info)
    settled_value, pending_value, uncharged_value, settled_time, pending_time, uncharged_time, settled_count, pending_count, uncharged_count, last_transaction_id, i = Array.new(11){0}
    last_transaction_id = payment_info["data"].first["id"]
    transaction_type = {
      settled: 'transaction["action"] == "charge" && transaction["actor"]["display_name"] != self.name && transaction["status"] == "settled"',
      pending: 'transaction["action"] == "charge" && transaction["actor"]["display_name"] != self.name && transaction["status"] == "pending"',
      uncharged: 'transaction["action"] == "pay" && transaction["actor"]["display_name"] == self.name'
    }

    payments = {"name"=>"","children"=>[
      {"name"=>"settled","children"=>[]},
      {"name"=>"pending","children"=>[]},
      {"name"=>"uncharged","children"=>[]},
    ]} #Payment JSON setup

    payment_info["data"].each do |transaction|
      if eval(transaction_type[:settled])
        settled_value = Transaction.increment_value(transaction, settled_value)
        settled_time = Transaction.increment_time(transaction, settled_time)
        settled_count += 1
        payments = PaymentHash.add_to_payment_json(transaction,payments,"settled")
      elsif eval(transaction_type[:pending])
        pending_value = Transaction.increment_value(transaction, pending_value)
        pending_time = Transaction.increment_time(transaction, pending_time)
        pending_count += 1
        payments = PaymentHash.add_to_payment_json(transaction,payments,"pending")
      elsif eval(transaction_type[:uncharged])
        uncharged_value = Transaction.increment_value(transaction, uncharged_value)
        uncharged_time = Transaction.increment_time(transaction, uncharged_time)
        uncharged_count += 1
        payments = PaymentHash.add_to_payment_json(transaction,payments,"uncharged")
      end
    end

    values = [settled_value, pending_value, uncharged_value]
    times = [settled_time, pending_time, uncharged_time]
    counts = [settled_count, pending_count, uncharged_count]

    ratios = Transaction.get_ratios(*values, *times)
    venmo_score = Transaction.calculate_score(ratios, *counts)

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

    PaymentHash.write_hash_to_json(payments)

  end

  def self.login_or_create(auth_hash)
    find_by(venmo_uid: auth_hash.uid) || create(name: auth_hash.extra.raw_info.display_name, venmo_uid: auth_hash.uid)
  end

end
