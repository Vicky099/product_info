class ProductsController < ApplicationController

	before_action :authenticate_user!
	before_action :set_type

	def index
		if params[:search].present?
			@products = type_class.where("user_id = ?", current_user.id).where("brand ilike (?) AND model ilike (?) AND ram ilike (?) AND ext_storage ilike (?)", "%#{params[:brand]}%", "%#{params[:model]}%", "%#{params[:ram]}%", "%#{params[:ext_storage]}%").order('id DESC').paginate(page: params[:page], per_page: 25)
		else
			@products = type_class.where(user_id: current_user.id).order('id DESC').paginate(page: params[:page], per_page: 25)
		end
		respond_to do |format|
			format.html
			format.js
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

	#def download
	#	DownloadWorker.perform_async(current_user.id)
	#	flash[:notice]= "Product list download will be in process. Please wait few second."
	#	redirect_to products_path
	#end

	def export
    	respond_to do |format|
      		format.json do
        		job_id = DownloadWorker.perform_async(current_user.id)
        		render json: {
          			jid: job_id
        		}
      		end
    	end
  	end

  	def export_status
    	respond_to do |format|
      		format.json do
        		job_id = params[:job_id]
        		job_status = Sidekiq::Status.get_all(job_id).symbolize_keys

        		render json: {
          			status: job_status[:status],
          			percentage: job_status[:pct_complete]
        		}
      		end
    	end
  	end

  	def export_download
    	job_id = params[:id]
    	exported_file_name = "products_export_#{job_id}.xlsx"
    	filename = "productData_#{DateTime.now.strftime("%Y%m%d_%H%M%S")}"

    	respond_to do |format|
      		format.xlsx do
        		send_file Rails.root.join("tmp", exported_file_name), type: "application/xlsx", filename: filename
      		end
    	end
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
