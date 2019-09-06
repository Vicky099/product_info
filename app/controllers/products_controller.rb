class ProductsController < ApplicationController

	before_action :authenticate_user!
	before_action :set_type

	def index
		if params[:search].present?
			@products = type_class.where("user_id = ?", current_user.id).where("brand like (?) AND model like (?) AND ram like (?) AND ext_storage like (?)", "%#{params[:brand]}%", "%#{params[:model]}%", "%#{params[:ram]}%", "%#{params[:ext_storage]}%").order('id DESC').paginate(page: params[:page], per_page: 25)
		else
			@products = type_class.where(user_id: current_user.id).order('id DESC').paginate(page: params[:page], per_page: 25)
		end
	end

	def new
		@product = type_class.new
	end

	def create
		@product = current_user.products.new(product_params)
		if @product.save
			flash[:success] = "Product information added successfully."
			redirect_to products_path
		else
			flash[:alert] = "Please try again OR contact Administrator."
			render :new
		end
	end

	def show
		@product = current_user.products.find_by_id(params[:id])
	end

	private
	def product_params
		params.require(type_name.underscore.to_sym).permit(:type, :name, :model, :brand, :year, :ram, :ext_storage, :color, :user_id)
	end

	def set_type
    	@type_name = type_name
  	end

	def type_name
		Product.childs.include?(params[:type]) ? params[:type] : "Product"
	end

	def type_class
    	type_name.constantize
  	end
end
