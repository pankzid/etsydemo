class Order < ActiveRecord::Base
  belongs_to :listing
  belongs_to :buyer, class_name: "User"
  belongs_to :seller, class_name: "User"

  scope :sales, ->(user){ where(seller: user) }
  scope :purchases, ->(user){ where(buyer: user) }
end
