class GlobalContext

  class Error < StandardError
    attr_reader :code
    def initialize(message, code)
      super(message)
      @code = code
    end
  end

  def self.create_admin
    data = {
      user_id: -1,
      rights: [],
      roles: ["admin"]
    }
    new(params: {}, cookies: {}, session: {}, jwk_repository: nil, jwt: data, jwt_unverified: data)
  end

  attr_reader :jwk_repository,
              :params,
              :cookies,
              :headers

  def initialize(params:, cookies:, session:, jwk_repository:, headers: nil, jwt: nil, jwt_unverified: nil)
    @params = params
    @cookies = cookies
    @jwk_repository = jwk_repository
    @session = session
    @jwt_unverified = jwt_unverified
    @jwt = jwt
    @headers = headers
  end

  def jwt_issuer
    ENV['JWT_ISSUER']||"https://jca.experteer.com/assembly_line"
  end

  def request_id
    @request_id ||= SecureRandom.uuid
  end

  def bearer_header
    headers && headers["Authorization"] ? headers["Authorization"].split('Bearer ').last : nil
  end

  def jwt_token
    @jwt_token ||= params[:jwt]||cookies[:jwt]||bearer_header
  end

  def jwt_unverified
    @jwt_unverified ||= JSON.parse(Base64.decode64(jwt_token.split(".")[1]))
  rescue => e
    puts e.message
    @jwt_unverified ||= {
      error: "Invalid Token"
    }
  end

  def error!(msg, code)
    raise Error.new(msg, code)
  end

  def jwt
    @jwt ||= JWT.decode(
      jwt_token, nil, true,
      { algorithms: ['RS256', 'RS512'], jwks: jwk_repository.call}
    )[0]
  rescue JWT::ExpiredSignature
    error! "Signature Invalid", 401
  rescue JWT::ImmatureSignature
    error! "Signature not valid yet", 401
  rescue JWT::InvalidIssuerError
    error! "Token was issued by wrong party", 401
  rescue JWT::VerificationError
    error! "Token was signed by an invalid key", 401
  rescue JWT::DecodeError => e
    error! "Jwt could not be decoded", 401
  rescue JWT::JWKError
    error! "Jwk seams to be broken", 401
  rescue JWT::InvalidAudError
    error ! "InvalidAudError", 401
  rescue JWT::InvalidSubError
    error ! "InvalidSubError", 401
  rescue JWT::InvalidIatError
    error ! "InvalidIatError", 401
  rescue JWT::InvalidJtiError
    error ! "InvalidJtiError", 401
  rescue => e
    puts e.class
    puts e.message
    error! "Unknown auth error", 401
  end

  def user_rights
    @user_rights ||= jwt["rights"]
  end

  def user_roles
    @user_roles ||= jwt["roles"]
  end

  def user_id
    @user_id ||= jwt["user_id"]
  end

  def user_email
    @user_email ||= jwt["user_email"]
  end

  def username
    @username ||= jwt["username"]
  end

  def can?(right)
    unless (right != nil && user_rights.include?(right.to_s)) || user_roles.include?("admin")
      error!("You are missing the right: #{right}", 403)
    end
    true
  end
end