# This module holds the Errors for the gem.
module Beekeeper::Error

  # The default error. It's never actually raised, but can be used to catch all
  # gem-specific errors that are thrown as they all subclass from this.
  class BeekeeperError < StandardError; end

  # Raised when invalid arguments are passed to a method.
  class ArgumentError < BeekeeperError; end

  # Raised when a request returns a 400.
  class ClientError < BeekeeperError; end

  # Raised when a request returns a 401.
  class UnauthorizedError < BeekeeperError; end

  # Raised when a request returns a 404.
  class NotFoundError < BeekeeperError; end

  # Raised when a request returns a 500.
  class ServerError < BeekeeperError; end

  # Raised when there is an unexpected response code / body.
  class UnexpectedResponseError < BeekeeperError; end
end
