class PagesController < ApplicationController
  attr_reader :products, :cart_total

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def add_product
    get_cart = create_cart
    check_cart_exist = CartsProduct.find_by(cart_id: get_cart.cart_id, product_id: params[:product_id])
    if check_cart_exist
      check_cart_exist.product_quantity += 1
      check_cart_exist.save
    else
      new_product_to_cart = CartsProduct.create(product_id: params[:product_id], cart_id: get_cart.cart_id)
      new_product_to_cart.save
    end
    redirect_to cart_path
  end

  def remove_product
    get_cart = create_cart
    check_cart_exist = CartsProduct.find_by(cart_id: get_cart.cart_id.to_i, product_id: params[:product_id])
    if check_cart_exist.product_quantity == 1
      CartsProduct.destroy(check_cart_exist.id)
    end
    if check_cart_exist.product_quantity >= 1
      check_cart_exist.product_quantity -= 1
      check_cart_exist.save
    end
    redirect_to cart_path
  end

  def cart
    get_cart = create_cart 
    @cart_total = 0
    return if get_cart.nil?
    @cart = Cart.find(get_cart.cart_id).carts_products.all
    # if @cart.empty?
    #   return Cart.destroy(get_cart.cart_id)
    # end
    @product_list=get_cart.products
    @products = {}
    @cart.each do |item|
      @products[item.product_id] = @product_list.select{|x|x  if x.product_id==item.product_id}
      @cart_total += (item.product_quantity) * @products[item.product_id].first.product_price
    end
    get_cart.cart_total=@cart_total
     get_cart.save
  end


  def buy_now
    new_cart=create_cart(true)
    CartsProduct.create(product_id:params[:id],cart_id:new_cart.cart_id)
    redirect_to cart_path
  end

  def place_order
    @order_place=false
    get_cart=create_cart
    get_cart.processed=true
    get_cart.save
    Order.create(cart_id:get_cart.cart_id,order_total:get_cart.cart_total,order_tax: get_tax(get_cart.cart_total))
    redirect_to cart_path
  end
  
  private

  def create_cart flag=false
    if Cart.count != 0 && !flag
      return Cart.find_by(processed:false)
    end
    @cart = Cart.new
    @cart.save
    @cart = Cart.last
  end

  def get_tax amount
    return (amount*1.05)-amount
  end
end
