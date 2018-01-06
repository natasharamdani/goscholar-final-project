class OrderObserver < ActiveRecord::Observer
  def after_save(order)
    if order.payment_type == "Go-Pay" && order.state == "Completed"
      Gopay.all.each do |gopay|
        @gopay = gopay if gopay.ref_type == "User" && gopay.ref_id == order.user_id
      end
      @gopay.balance -= order.price
    end
  end
end
