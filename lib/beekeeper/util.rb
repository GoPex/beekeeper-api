module Beekeeper::Util
  include Beekeeper::Error

  module_function

  def debug(msg)
    Beekeeper.logger.debug('Beekeeper::Api') {msg} if Beekeeper.logger
  end

  def parse_json(body)
    JSON.parse(body) unless body.nil? || body.empty? || (body == 'null')
  rescue JSON::ParserError => exception
    raise UnexpectedResponseError, exception.message
  end
end
