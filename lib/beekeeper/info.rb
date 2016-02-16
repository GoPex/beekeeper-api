class Beekeeper::Info

  def self.ping(connection: Beekeeper.connection)
    connection.get path_for('ping')
  end

  def self.status(connection: Beekeeper.connection)
    connection.get path_for('status')
  end

  def self.version(connection: Beekeeper.connection)
    connection.get path_for('version')
  end

  def self.docker_version(connection: Beekeeper.connection)
    connection.get path_for('docker_version')
  end

  def self.docker(connection: Beekeeper.connection)
    connection.get path_for('docker')
  end

  private

  # Convenience method to return the path for a particular resource.
  def self.path_for(end_point)
    "info/#{end_point}"
  end
end
