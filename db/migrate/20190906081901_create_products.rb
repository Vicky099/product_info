class CreateProducts < ActiveRecord::Migration[5.2]
	def change
		create_table :products do |t|
			t.references :user, index: true
			t.string :type
			t.string :name
			t.string :model
			t.string :brand
			t.string :year
			t.string :ram
			t.string :ext_storage
			t.string :color
			t.timestamps
		end
	end
end
