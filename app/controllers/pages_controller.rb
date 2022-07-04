class PagesController < ApplicationController
  attr_reader :products, :cart_total

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def add_product
    get_cart= create_cart
    get_cart=create_cart(true) if get_cart.nil?
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
    check_cart_exist = CartsProduct.find_by(cart_id: get_cart.cart_id, product_id: params[:product_id])
    if check_cart_exist.product_quantity == 1
      CartsProduct.destroy(check_cart_exist.id)
      if CartsProduct.find_by(cart_id:get_cart.cart_id).nil?
        Cart.destroy_by(cart_id:get_cart.cart_id)
      end
    end
    if check_cart_exist.product_quantity >= 1
      check_cart_exist.product_quantity -= 1
      check_cart_exist.save
    end
    redirect_to cart_path
  end

  def cart
    get_cart = create_cart 
    return  if get_cart.nil?
    @cart_total = 0
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
    @order_place=true if get_cart.save
    user=User.first
    Order.create(order_id:Time.now.to_i,cart_id:get_cart.cart_id,order_total:get_cart.cart_total,order_tax: get_tax(get_cart.cart_total),user_id:user.user_id)
    redirect_to root_path
  end
  
  private

  def get_tax amount
    return ((amount*1.05)-amount).round
  end
  
  def create_cart flag=false
    # if Cart.count!=0 && !flag
    #  return
    # end
    if flag
      @cart = Cart.new
      @cart.save
      @cart = Cart.last
    else
       @cart=Cart.order(cart_id: :desc).find_by(processed:false)
    end
  end
end
