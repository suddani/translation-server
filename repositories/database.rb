class Database
  def self.conn
    @conn ||= ConnectionPool.new(size: 1, timeout: 5) { Sequel.connect(Application.database_config) }
  end
end