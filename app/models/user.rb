class User < ActiveRecord::Base

  def parse_info(payment_info)
    self.update_payment_totals(payment_info)
  end

  def update_payment_totals(payment_info)
    payment_total_value = 0
    payment_total_time = 0
    transaction_count = 0
    last_transaction_id = 0
    i = 0

    payment_info["data"].each do |transaction|
      if transaction["status"] == "settled" && transaction["action"] == "charge" && transaction["actor"]["display_name"] != self.name
        payment_total_value += transaction["amount"]
        
        t1 = Time.parse(transaction["date_created"])
        t2 = Time.parse(transaction["date_completed"])
        time_to_payment = (t2 - t1)/60
        payment_total_time += time_to_payment

        last_transaction_id = transaction["id"] if i == 0

        transaction_count += 1
        i=1
      end
    end

    venmo_score = self.calculate_score(payment_total_value, payment_total_time)
    self.update(payment_total_value: payment_total_value, payment_total_time: payment_total_time, last_transaction_id: last_transaction_id, venmo_score: venmo_score, transaction_count: transaction_count)
  end

  def calculate_score(payment_total_value, payment_total_time)
    # binding.pry
    (payment_total_time/payment_total_value).round(2)
  end

  def self.login_or_create(auth_hash)
    find_by(venmo_uid: auth_hash.uid) || create(name: auth_hash.extra.raw_info.display_name, venmo_uid: auth_hash.uid)
  end

end
