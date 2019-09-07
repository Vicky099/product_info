class DownloadWorker
	include Sidekiq::Worker
	sidekiq_options queue: :xlsx_download, retry: true, backtrace: true
	include Rails.application.routes.url_helpers


	def perform(*args)
		products = Product.where(user_id: args[0]).order('id ASC')

		package = Axlsx::Package.new do |p|
  			p.workbook.add_worksheet(name: "Summary") do |sheet|
    			sheet.add_row %w(id type name model brand color year ram ext_storage )
    			products.each do |product|
    				sheet.add_row [product.id, product.type, product.name, product.model, product.brand, product.color, product.year, product.ram, product.ext_storage]


    				sheet.add_hyperlink location: Rails.application.routes.url_helpers.product_url(:host => AppConfig.app['host'], id: product.id, only_path: false), ref: sheet.rows.last.cells.first
  				end
  			end
		end

		path = "#{Rails.root}/tmp/product_list.xlsx"
		File.open(path, "w") do |f|
  			f.write(package.to_stream.read)
		end
	end
end
