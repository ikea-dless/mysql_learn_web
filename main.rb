require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/namespace'
require './lib/database'
require 'jbuilder'

before do
  @db = Database.new
end

get '/' do
  <<-HTML
  <ul>
    <li>GET /messages</li>
    <li>GET /users</li>
  </ul>
  HTML
end

namespace '/messages' do
  get do
    content_type :json
    messages = @db.get_messages
    Jbuilder.encode do |json|
      json.messages messages do |message|
        json.id message['id']
        json.text message['text']
        json.user_id message['user_id']
      end
    end
  end

  get '/:id' do
    content_type :json
    message = @db.get_message_by_id(params[:id])
    Jbuilder.encode do |json|
      json.message do
        json.id message.first['id']
        json.text message.first['text']
        json.user_id message.first['user_id']
      end
    end
  end
end

namespace '/users' do
  get do
    content_type :json
    users = @db.get_users
    Jbuilder.encode do |json|
      json.users users do |user|
        json.id user['id']
        json.name user['name']
      end
    end
  end

  namespace '/:id' do
    get do
      content_type :json
      user = @db.get_user_by_id(params[:id])
      Jbuilder.encode do |json|
        json.user do
          json.id user.first['id']
          json.name user.first['name']
        end
      end
    end

    get '/messages' do
      content_type :json
      messages = @db.get_messages_by_user_id(params[:id])
      user = @db.get_user_by_id(params[:id])
      Jbuilder.encode do |json|
        json.messages messages do |message|
          json.id message['id']
          json.text message['text']
          json.user_id message['user_id']
          json.user do
            json.id user.first['id']
            json.name user.first['name']
          end
        end
      end
    end
  end
end
