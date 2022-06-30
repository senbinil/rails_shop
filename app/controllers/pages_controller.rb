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
    check_cart_exist = CartProduct.find_by(cart_id: get_cart.cart_id, product_id: params[:product_id])
    if check_cart_exist
      check_cart_exist.product_quantity += 1
      check_cart_exist.save
    else
      new_product_to_cart = CartProduct.create(product_id: params[:product_id], cart_id: get_cart.cart_id)
      new_product_to_cart.save
    end
    redirect_to cart_path
  end

  def remove_product
    get_cart = create_cart
    check_cart_exist = CartProduct.find_by(cart_id: get_cart.cart_id.to_i, product_id: params[:product_id])
    if check_cart_exist.product_quantity == 1
      CartProduct.delete(check_cart_exist)
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
    @cart = Cart.find(get_cart.cart_id).cart_products.all
    if @cart.empty?
      return Cart.delete(get_cart.cart_id)
    end
    @products = {}
    @cart.each do |item|
      @products[item.product_id] = [Product.find(item.product_id)]
      @cart_total += (item.product_quantity) * @products[item.product_id].first.product_price
    end
  end


  def buy_now
    new_cart=create_cart(true)
    CartProduct.create(product_id:params[:id],cart_id:new_cart.cart_id)
    redirect_to cart_path
  end

  def place_order
    @order_place=false
    get_cart=create_cart
    if Cart.delete(get_cart.cart_id)
      @order_place=true
    end
    redirect_to cart_path
  end
  
  private

  def create_cart flag=false
    if Cart.count != 0 && !flag
      return (@cart = Cart.last)
    end
    @cart = Cart.new
    @cart.save
    @cart = Cart.last
  end
end