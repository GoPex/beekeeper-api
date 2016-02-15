require 'test_helper'

class Beekeeper::BeeTest < Minitest::Test

  def setup
    setup_beekeeper
  end

  def teardown
    setup_beekeeper
    Beekeeper::Bee.all.each do |bee|
      bee.delete!
    end
    teardown_beekeeper
  end

  def test_should_get_all_bees
    5.times do
      create_test_bee
    end
    bees = Beekeeper::Bee.all
    assert_equal 5, bees.count
  end

  def test_should_create_bee
    bee = create_test_bee
    refute_nil bee
    assert_equal 'running', bee.last_status

    an_other_bee = Beekeeper::Bee.get(bee.id)
    refute_nil an_other_bee
    assert_equal 'running', an_other_bee.last_status
  end

  def test_should_create_and_get_bee
    bee = create_test_bee
    refute_nil bee
    assert_equal 'running', bee.last_status

    an_other_bee = Beekeeper::Bee.get(bee.id)
    refute_nil an_other_bee
    assert_equal 'running', an_other_bee.last_status
  end

  def test_should_create_and_delete_bee
    bee = create_test_bee
    refute_nil bee
    assert_equal 'running', bee.last_status

    assert_equal 'deleted', bee.delete!
    assert_equal 'deleted', bee.last_status

    assert_raises Beekeeper::Error::NotFoundError do
      Beekeeper::Bee.get(bee.id)
    end
  end

  def test_should_create_and_update_bee_status
    bee = create_test_bee
    refute_nil bee
    assert_equal 'running', bee.last_status
    assert_equal 'running', bee.status!
  end

  def test_should_get_unauthorized_with_wrong_api_key
    Beekeeper.api_key = 'WRONG_API_KEY'
    assert_raises Beekeeper::Error::UnauthorizedError do
      Beekeeper::Bee.all
    end
  end

end
