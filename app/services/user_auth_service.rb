class UserAuthService
  def initialize(params)
    @params = params
  end

  def authenticated?
    user.present?
  end
  
end