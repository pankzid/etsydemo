class AddSellerIdAndBuyerIdToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :seller, index: true
    add_reference :orders, :buyer, index: true
  end
end
