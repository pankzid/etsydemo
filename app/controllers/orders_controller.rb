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

    Stripe.api_key = ENV["STRIPE_API_KEY"]
    card_token = params[:cardToken]

    begin
      Stripe::Charge.create(
        amount: (@listing.price*100).floor,
        currency: "usd",
        card: card_token
        )
      flash[:notice] = "Thanks for ordering"
    rescue Stripe::CardError => e
      flash[:danger] = e.message
    end

    Stripe::Transfer.create(
      :amount => (@listing.price*95).floor,
      :currency => "usd",
      :recipient => @listing.user.recipient,
      :description => "Transfer for #{@listing.user.name_title}"
    )

    respond_to do |format|
      if @order.save
        format.html { redirect_to root_path }
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
