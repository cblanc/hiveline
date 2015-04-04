require 'hiveline/version'
require 'httparty'
require 'json'

module Hiveline
	class Client
		include HTTParty
		attr_accessor :username, :password, :session, :ui_session, :api_session

		def initialize(username, password)
			@username = username
			@password = password
		end

		def api_session
			@api_session ||= session_ids[:api_session]
		end

		def ui_session
			@ui_session ||= session_ids[:ui_session]
		end

		def session_ids
			@session ||= get_session_ids
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
					"Cookie" => "ApiSession=#{self.api_session}; UiSession=#{self.ui_session}",
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
			weather_url = "https://api.hivehome.com/v5/users/#{self.username}/widgets/temperature"
			response = self.class.get(weather_url, {
				headers: {
					"Cookie" => "ApiSession=#{self.api_session}; UiSession=#{self.ui_session}",
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
					"Cookie" => "ApiSession=#{self.api_session}; UiSession=#{self.ui_session}",
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

		def get_session_ids
			login_url = "https://api.hivehome.com/v5/login"
			response = self.class.post(login_url, {
				body: {
					username: @username,
					password: @password
				}, 
				follow_redirects: false
			})
			body = JSON.parse(response.body)
			{
				api_session: body["ApiSession"],
				ui_session: body["UiSession"]
			}
		end
	end
end