require 'hiveline/version'
require 'httparty'
require 'json'

module Hiveline
	class Client
		include HTTParty
		attr_accessor :username, :password, :session

		def initialize(username, password)
			@username = username
			@password = password
		end

		def session
			@session ||= retrieve_session
		end

		def set_temperature(temp)
			heating_url = "https://my.hivehome.com/heating/target"
			id = self.session
			response = self.class.put(heating_url, {
				body: {
					id:1,
					target:temp
				},
				headers: {
					"Cookie" => "hsid=#{id}"
				},
				follow_redirects: false
			})

			if response.code == 200
				JSON.parse(response.body)["target"]
			else
				nil
			end
		end

		def get_temperature
			weather_url = "https://my.hivehome.com/weather"
			response = self.class.get(weather_url, {
				headers: {
					"Cookie" => "hsid=#{self.session}",
					"Content-Type" => "application/json"
				},
				follow_redirects: false
			})
			if response.code == 200
				JSON.parse(response.body)
			else
				nil
			end
		end

		def get_history
			history_url = "https://my.hivehome.com/history/today"
			response = self.class.get(history_url, {
				headers: {
					"Cookie" => "hsid=#{self.session}",
					"Content-Type" => "application/json"
					},
				follow_redirects: false
			})
			if response.code == 200
				JSON.parse(response.body)
			else
				nil
			end
		end

		private

		def retrieve_session
			extract_session_id login
		end
		
		def extract_session_id(response)
			id_attribute_regex = /^hsid=/
			set_cookie_header = response.headers["set-cookie"]
			set_cookie_header
				.split(";")
				.each(&:strip!)
				.grep(id_attribute_regex)
				.first
				.gsub(id_attribute_regex, "")
		end

		def login
			login_url = "https://my.hivehome.com/login"
			self.class.post(login_url, {
				body: {
					username: @username,
					password: @password
				}, 
				follow_redirects: false
			})
		end
	end
end