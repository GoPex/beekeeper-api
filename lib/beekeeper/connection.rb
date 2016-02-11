# This class represents a Connection to a Beekeeper server. The Connection is
# immutable in that once the url and options is set they cannot be changed.
class Beekeeper::Connection
  include Beekeeper::Error

  attr_reader :url, :access_id, :options

  def initialize(url, access_id, options)
    case
    when !url.is_a?(String)
      raise ArgumentError, "Expected a String, got: '#{url}'"
    when !access_id.is_a?(String)
      raise ArgumentError, "Expected an String, got: '#{access_id}'"
    when !options.is_a?(Hash)
      raise ArgumentError, "Expected a Hash, got: '#{options}'"
    else
      uri = URI.parse(url)
      puts uri
      if uri.scheme == "unix"
        @url, @access_id, @options = 'unix:///', access_id, {socket: uri.path}.merge(options)
      elsif uri.scheme =~ /^(https?|tcp)$/
        @url, @access_id, @options = url, access_id, options
      else
        @url, @access_id, @options = "http://#{uri}", access_id, options
      end
    end
  end

  # Send a request to the server with the `
  def request(method, path, payload)
    # Get the user's secret
    secret_key = Beekeeper.api_key
    unless secret_key
      raise AuthenticationError, "No secret found for #{access_id} !"
    end

    # Construct the header, Content-MD5 and date are set by ApiAuth
    headers = { 'Content-Type' => "application/json",
                'Accept' => "json",
                'User-Agent' => "GoPex/Beekeeper-Api #{Beekeeper::VERSION}"
                }

    # Construct the request
    request = RestClient::Request.new(url: "#{url}/#{path}",
                                      headers: headers,
                                      method: method,
                                      payload: payload.to_json)

    # Sign the request
    ApiAuth.sign!(request, access_id, secret_key)

    # Log the request for debugging purposes
    Beekeeper::Util.debug("Sending: '#{method} /#{path}' request to Beekeeper using connection (url: '#{self.url}', options: '#{self.options}') - '#{request.inspect}'")

    # Send the http request
    response = Beekeeper::Util.parse_json(request.execute.body)

    # Log the response for debugging purposes
    Beekeeper::Util.debug("Response: '#{response}'")

    # Return the JSON parsed response to the caller
    response
  rescue RestClient::BadRequest => exception
    raise ClientError, parse_exception(exception)
  rescue RestClient::Unauthorized => exception
    raise UnauthorizedError, "Unauthorized request for access id '#{access_id}' !"
  rescue RestClient::ResourceNotFound => exception
    raise NotFoundError, parse_exception(exception)
  rescue RestClient::InternalServerError => exception
    raise ServerError, parse_exception(exception)
  end

  # Delegate all HTTP methods to the #request.
  [:get, :delete].each do |method|
    define_method(method) { |path| request(method, path, {}) }
  end

  [:post].each do |method|
    define_method(method) { |path, payload| request(method, path, payload) }
  end

  def to_s
    "Beekeeper::Connection { :url => #{url}, :options => #{options} }"
  end

  private

  def parse_exception(exception)
    Beekeeper::Util.parse_json(exception.response)['exception']
  end
end
