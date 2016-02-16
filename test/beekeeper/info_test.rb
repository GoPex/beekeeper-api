require 'test_helper'

class Beekeeper::InfoTest < Minitest::Test

  def setup
    setup_beekeeper
  end

  def teardown
    teardown_beekeeper
  end

  def test_should_get_info_ping
    response = Beekeeper::Info.ping
    assert_equal 'OK', response['pong']
  end

  def test_should_get_info_status
    response = Beekeeper::Info.status
    assert_equal 'OK', response['status']
    assert_equal 'OK', response['docker_host_status']
  end

  def test_should_get_info_version
    response = Beekeeper::Info.version
    refute_nil response['version']
    refute_nil response['api_version']
  end

  def test_should_get_info_docker
    response = Beekeeper::Info.docker
    refute_nil response['ServerVersion']
  end

  def test_should_get_info_docker_version
    response = Beekeeper::Info.docker_version
    refute_nil response['Version']
  end

  def test_should_get_unauthorized_with_wrong_api_key
    Beekeeper.api_key = 'WRONG_API_KEY'
    assert_raises Beekeeper::Error::UnauthorizedError do
      Beekeeper::Info.version
    end
  end
end
