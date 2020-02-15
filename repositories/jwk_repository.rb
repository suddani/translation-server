class JwkRepository
  def self.load_data
    JSON.parse(Net::HTTP.get_response(URI('http://auth-server:3000/jwk')).body, symbolize_names: true)
  end

  def self.cached
    @cached ||= load_data
  end

  def self.call
    cached
  end
end