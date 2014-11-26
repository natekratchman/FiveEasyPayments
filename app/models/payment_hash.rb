class PaymentHash

def self.add_to_payment_json(transaction,payments,type)
    
    if type=="settled"
      child = payments["children"][0]["children"].select{|h| h["name"]==transaction["actor"]["display_name"]}
      if child == []
        child = payments["children"][0]["children"].push({"name"=>transaction["actor"]["display_name"],"children"=>[]})
      end
      child[0]["children"].push({"name"=>transaction["note"],"amount"=>transaction["amount"],"size"=>1})
    elsif type == "pending"
      child = payments["children"][1]["children"].select{|h| h["name"]==transaction["actor"]["display_name"]}
      if child == []
        child = payments["children"][1]["children"].push({"name"=>transaction["actor"]["display_name"],"children"=>[]})
      end
      child[0]["children"].push({"name"=>transaction["note"],"amount"=>transaction["amount"],"size"=>1})
    elsif type == "uncharged"
      child = payments["children"][2]["children"].select{|h| h["name"]==transaction["target"]["user"]["display_name"]}
      if child == []
        child = payments["children"][2]["children"].push({"name"=>transaction["target"]["user"]["display_name"],"children"=>[]})
      end
      child[0]["children"].push({"name"=>transaction["note"],"amount"=>transaction["amount"],"size"=>1})
    end

    payments
  end

  def self.write_hash_to_json(payments)
    File.open("public/payments.json","w") do |f|
      f.write(JSON.pretty_generate(payments))
    end
  end

end