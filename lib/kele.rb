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

  def user_auth
    {headers: {
      authorization: @auth_token
    }}
  end
end
