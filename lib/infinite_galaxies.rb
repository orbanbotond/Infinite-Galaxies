# frozen_string_literal: true

require 'infra'
require 'debug'

require_relative 'events/events'
require_relative 'game'
# require_relative 'time_harvest/time_harvest_service'
# require_relative 'time_harvest/commands/create_account'

module InfiniteGalaxies
	class Configuration
		def call(cqrs)
			# cqrs.register_command(CreateAccount, CreateAccountHandler.new(cqrs.event_store), Events::AccountCreatedForUser)
		end
	end
end
