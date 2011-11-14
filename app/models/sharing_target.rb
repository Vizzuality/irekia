class SharingTarget
	include ActiveModel::Validations

	attr_accessor :email

  validates :email, :presence => true, :format => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/

	def initialize(email)
		self.email = email
	end
end
