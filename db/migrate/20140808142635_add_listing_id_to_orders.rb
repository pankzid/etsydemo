class AddListingIdToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :listing, index: true
  end
end
