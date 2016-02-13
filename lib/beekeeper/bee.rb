# This class represent a Bee
class Beekeeper::Bee
  include Beekeeper::Error

  attr_accessor :connection
  attr_reader :id, :addresses, :last_status

  def self.create(image, entrypoint: nil, parameters: [], ports: [], connection: Beekeeper.connection)
    bee_options = {container: {image: image, entrypoint: entrypoint, parameters: parameters, ports: ports}}
    response = connection.post path_for_bees, bee_options
    new(connection, response)
  end

  def delete!
    @last_status = self.class.delete(id, connection)
  end

  def self.delete(id, connection: Beekeeper.connection)
    response = connection.delete Beekeeper::Bee.path_for_bees(id)
    response['status']
  end

  def self.get(id, connection: Beekeeper.connection)
    response = connection.get path_for_bees(id)
    new(connection, response)
  end

  def self.all(connection: Beekeeper.connection)
    responses = connection.get(path_for_bees)
    bees = []
    responses.each do |id, body|
      response = body.merge({'id' => id})
      bees.push(new(connection, response))
    end
    bees
  end

  def status!(connection: Beekeeper.connection)
    refreshed_bee = Beekeeper::Bee.get(self.id)
    @last_status = refreshed_bee.last_status
  end

  private

  # Convenience method to return the path for a particular resource.
  def self.path_for_bees(id='')
    if id.empty?
      'bees'
    else
      "bees/#{id}"
    end
  end

  private_class_method

  def initialize(connection, attributes={})
    @connection = connection
    @id = attributes['id']
    @addresses = attributes['addresses']
    @last_status = attributes['status']
  end
end
