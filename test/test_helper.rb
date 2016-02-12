$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'beekeeper'

require 'minitest/autorun'

def setup_beekeeper
  Beekeeper.url = 'http://172.17.0.1:3000'
  Beekeeper.access_id = 1337
  Beekeeper.api_key = 'ALMOST_PASTED_IT'
end

def teardown_beekeeper
  Beekeeper.url = nil
  Beekeeper.access_id = nil
  Beekeeper.api_key = nil
end
