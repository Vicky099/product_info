class ClearOldUserExportsJob
	@queue = :clear_old_user_exports

	def perform
		ClearOldUserExportsService.clear
	end
end
