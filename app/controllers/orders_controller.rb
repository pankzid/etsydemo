class OrdersController < ApplicationController
  # before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :listing, except: [:sales, :purchases]

  def sales
    @orders = Order.sales(current_user).includes([:listing, :buyer]).recent
  end

  def purchases
    @orders = Order.purchases(current_user).includes([:listing, :seller]).recent
  end

  # GET /orders/new
  def new
    @order = Order.new
    @listing = listing
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @listing = listing

    @order.buyer_id = current_user.id
    @order.seller_id = @listing.user.id
    @order.listing_id = @listing.id

    respond_to do |format|
      if @order.save
        format.html { redirect_to root_path, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_order
    #   @order = Order.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:address, :city, :state)
    end

    def listing
      Listing.find(params[:listing_id])
    end
end
