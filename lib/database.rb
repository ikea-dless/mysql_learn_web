require 'mysql2'
require 'yaml'

class Database
  def initialize
    conf = YAML.load_file('database.yml')
    @client = Mysql2::Client.new(conf)
  end

  def get_messages
    @client.query('SELECT * FROM messages;')
  end

  def get_users
    @client.query('SELECT * FROM users;')
  end

  def get_messages_by_user_id(user_id = nil)
    statment = @client.prepare('SELECT * FROM messages WHERE user_id = ?')
    statment.execute(user_id)
  end

  def get_user_by_id(id = nil)
    statment = @client.prepare('SELECT * FROM users WHERE id = ?')
    statment.execute(id)
  end

  def get_message_by_id(id = nil)
    statment = @client.prepare('SELECT * FROM messages WHERE id = ?')
    statment.execute(id)
  end

  def get_message_user_by_id(id = nil)
    statment = @client.prepare('SELECT * FROM messages LEFT JOIN users ON messages.user_id = users.id WHERE messages.id = ?');
    statment.execute(id);
  end
end
