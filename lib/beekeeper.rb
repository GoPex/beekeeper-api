require 'json'
require 'logger'
require 'uri'
require 'rest-client'
require 'api-auth'

# The top-level module for this gem. It's purpose is to hold global
# configuration variables that are used as defaults in other classes.
module Beekeeper
  attr_accessor :logger, :access_id, :api_key

  require 'beekeeper/error'
  require 'beekeeper/util'
  require 'beekeeper/connection'
  require 'beekeeper/version'

  require 'beekeeper/info'
  require 'beekeeper/bee'

  def env_url
    ENV['BEEKEEPER_URL'] || ENV['BEEKEEPER_HOST']
  end

  def url
    @url ||= env_url
  end

  def url=(new_url)
    @url = new_url
    reset_connection!
  end

  def connection
    @connection ||= Connection.new(url, access_id, options)
  end

  def reset_connection!
    @connection = nil
  end

  def env_options
    {}
  end

  def options
    @options ||= env_options
  end

  def options=(new_options)
    @options = env_options.merge(new_options || {})
    reset_connection!
  end

  module_function :env_url, :url, :url=,
                  :env_options, :options, :options=,
                  :logger, :logger=,
                  :access_id, :access_id=,
                  :api_key, :api_key=,
                  :connection, :reset_connection!
end
