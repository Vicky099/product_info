class Product < ApplicationRecord

	validates :name, presence: true
	validates :model, presence: true
	validates :brand, presence: true
	validates :year, presence: true
	validates :ram, presence: true
	validates :ext_storage, presence: true
	validates :color, presence: true

	scope :mobiles, -> {where(type: 'Mobile')}
	scope :tvs, -> {where(type: 'TV')}

	class << self
		def childs
			%w(Mobile Tv)
		end
	end
end
