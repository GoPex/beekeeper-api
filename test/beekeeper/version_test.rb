require 'test_helper'

class Beekeeper::VesrionTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Beekeeper::VERSION
  end

  def test_that_it_has_a_beekeeper_api_version_number
    refute_nil ::Beekeeper::API_VERSION
  end
end
