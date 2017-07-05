require 'httparty'
require 'json'
require "awesome_print"
require './lib/roadmap.rb'

class Kele
  include HTTParty
  include Roadmap

  def initialize(email, password)
    response = self.class.post(api_url("sessions"), body: { "email": email, "password": password })
    raise "Invalid email or password" if response.code == 404
    @auth_token = response["auth_token"]
  end

  def get_me
    response = self.class.get(api_url("users/me"), user_auth)
    @user_data = JSON.parse(response.body)
  end

  def get_mentor_availability(id)
    response = self.class.get(api_url("mentors/#{id}/student_availability"), user_auth)
    @mentor_data = JSON.parse(response.body)
  end

  def api_url(endpoint)
    "https://www.bloc.io/api/v1/#{endpoint}"
  end

  def get_messages(page=nil)
    if page=nil
      response = self.class.get(api_url("message_threads"), user_auth)
    else
      response = self.class.get(api_url("message_threads?#{page}"), user_auth)
    end
    @message_data = JSON.parse(response.body)
  end

  def create_message(user_id, recipient_id, token=nil, subject, message)
    response = self.class.post(api_url("messages"),
      body: {
        "user_id": user_id,
        "recipient_id": recipient_id,
        "token": token,
        "subject": subject,
        "stripped_text": message
      }, headers: { authorization: @auth_token
      })
  end

  def user_auth
    {headers: {
      authorization: @auth_token
    }}
  end
end
