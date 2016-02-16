Beekeeper::Api
==============

Installation
------------

Add this line to your application's Gemfile:

```ruby
gem 'beekeeper-api'
```

And then execute:

```shell
bundle
```

Usage documentation
-------------------

### Infos

#### Get beekeeper version
```ruby
Beekeeper::Info.version
 => JSON
```

#### Get Docker daemon version of the Docker host used by Beekeeper
```ruby
Beekeeper::Info.docker_version
 => JSON
```

#### Get Docker daemon information of the Docker host used by Beekeeper
```ruby
Beekeeper::Info.docker
 => JSON
```

### Bees

#### Get a bee

```ruby
bee = Beekeeper::Bee.get(id)
 => a bee, Beekeeper::Bee
```

#### Get all the bees

```ruby
bees = Beekeeper::Bee.all
 => list of managed bees, [Beekeeper::Bee]
```

#### Create a bee

```ruby
bee = Beekeeper::Bee.create(image, entrypoint: entrypoint, parameters: [param, ], ports: [port, ])
 => new instance, Beekeeper::Bee
```

#### Destroy a bee

```ruby
status = Beekeeper::Bee.delete(id)
 => status, String
```

#### Manage your living bee

```ruby
bee.status!
 => status, String, @last_status updated
```

```ruby
bee.delete!
 => status, String, @last_status updated
```

Usage examples
--------------

### Standalone

```ruby
require 'beekeeper'

# Assuming that your Beekeeper instance is running on your localhost port 3000
Beekeeper.url = 'http://localhost:3000'

# Assuming that Beekeeper was launched with -e 1337_API_KEY=ALMOST_PASTED_IT
Beekeeper.access_id = 1337
Beekeeper.api_key = 'ALMOST_PASTED_IT'

# Let's get started
Beekeeper::Info.version
=> {"version"=>"0.3.0", "api_version"=>"1"}

Beekeeper::Info.docker
=> {"ID"=>"PQG4:CP74:KW4R:RO2W:MH3P:6KTD:JC4R:BZLS:BHKZ:V5KI:KDBB:6XBA", "Containers"=>2, "Images"=>386, "Driver"=>"aufs", "DriverStatus"=>[["Root Dir", "/var/lib/docker/aufs"], ["Backing Filesystem", "extfs"], ["Dirs", "394"], ["Dirperm1 Supported", "true"]], "MemoryLimit"=>true, "SwapLimit"=>false, "CpuCfsPeriod"=>true, "CpuCfsQuota"=>true, "IPv4Forwarding"=>true, "BridgeNfIptables"=>true, "BridgeNfIp6tables"=>true, "Debug"=>false, "NFd"=>30, "OomKillDisable"=>true, "NGoroutines"=>62, "SystemTime"=>"2016-02-11T08:46:28.350650478+01:00", "ExecutionDriver"=>"native-0.2", "LoggingDriver"=>"json-file", "NEventsListener"=>0, "KernelVersion"=>"4.2.0-25-generic", "OperatingSystem"=>"Ubuntu 15.10", "IndexServerAddress"=>"https://index.docker.io/v1/", "RegistryConfig"=>{"InsecureRegistryCIDRs"=>["127.0.0.0/8"], "IndexConfigs"=>{"docker.io"=>{"Name"=>"docker.io", "Mirrors"=>nil, "Secure"=>true, "Official"=>true}}, "Mirrors"=>nil}, "InitSha1"=>"6bd1e8a0cd16ab554af196c6ab421437489d902f", "InitPath"=>"/usr/lib/docker/dockerinit", "NCPU"=>4, "MemTotal"=>4024819712, "DockerRootDir"=>"/var/lib/docker", "HttpProxy"=>"", "HttpsProxy"=>"", "NoProxy"=>"", "Name"=>"AlbinOS", "Labels"=>nil, "ExperimentalBuild"=>false, "ServerVersion"=>"1.9.1", "ClusterStore"=>"", "ClusterAdvertise"=>""}

Beekeeper::Info.docker_version
=> {"Version"=>"1.9.1", "ApiVersion"=>"1.21", "GitCommit"=>"a34a1d5", "GoVersion"=>"go1.4.2", "Os"=>"linux", "Arch"=>"amd64", "KernelVersion"=>"4.2.0-25-generic", "BuildTime"=>"Fri Nov 20 13:20:08 UTC 2015"}

bee = Beekeeper::Bee.create('gopex/beekeeper_test_image:latest', entrypoint: 'tail', parameters: ['-f', '/dev/null'], ports: ['3000/tcp'])
=> #<Beekeeper::Bee:0x005627fdfca7d0 @connection=#<Beekeeper::Connection:0x005627fdf27e18 @url="http://172.17.0.1:3001", @access_id="1337", @options={}>, @id="6b4f603d65c06c62990041016972fc18cdbe74365db7426bce3ddace55004f57", @addresses={"3000/tcp"=>"0.0.0.0:32826"}, @last_status="running">

an_other_bee = Beekeeper::Bee.get(bee.id)
=> #<Beekeeper::Bee:0x005627fdffbb50 @connection=#<Beekeeper::Connection:0x005627fdf27e18 @url="http://172.17.0.1:3001", @access_id="1337", @options={}>, @id="6b4f603d65c06c62990041016972fc18cdbe74365db7426bce3ddace55004f57", @addresses={"3000/tcp"=>"0.0.0.0:32826"}, @last_status="running">

an_other_bee.status!
=> "running"

an_other_bee.delete!
=> "deleted"

5.times do
    Beekeeper::Bee.create('gopex/beekeeper_test_image:latest', entrypoint: 'tail', parameters: ['-f', '/dev/null'], ports: ['3000/tcp'])
end
=> 5

Beekeeper::Bee.all
=> [#<Beekeeper::Bee:0x005627fdb28970 @connection=#<Beekeeper::Connection:0x005627fdf27e18 @url="http://172.17.0.1:3001", @access_id="1337", @options={}>, @id="46f8bdb4c0ba5a6aa396d01c48e4a765d9ab5d3057651e11705e544aceb8892e", @addresses={"3000/tcp"=>"0.0.0.0:32831"}, @last_status="running">, #<Beekeeper::Bee:0x005627fdb28678 @connection=#<Beekeeper::Connection:0x005627fdf27e18 @url="http://172.17.0.1:3001", @access_id="1337", @options={}>, @id="b3c65fbc0b2c3a22d777b1c92bb55022dbd7dd6e5797461785327ba8de85f527", @addresses={"3000/tcp"=>"0.0.0.0:32830"}, @last_status="running">, #<Beekeeper::Bee:0x005627fdb28218 @connection=#<Beekeeper::Connection:0x005627fdf27e18 @url="http://172.17.0.1:3001", @access_id="1337", @options={}>, @id="e565c79f704ce51390f4525450697e123c89486b8faa511c522ec14c34929a23", @addresses={"3000/tcp"=>"0.0.0.0:32829"}, @last_status="running">, #<Beekeeper::Bee:0x005627fdb28330 @connection=#<Beekeeper::Connection:0x005627fdf27e18 @url="http://172.17.0.1:3001", @access_id="1337", @options={}>, @id="104df6b88209b074c79b5a7fe85bd155c3e01e4300718b3080f082acfb091a7f", @addresses={"3000/tcp"=>"0.0.0.0:32828"}, @last_status="running">, #<Beekeeper::Bee:0x005627fdb289c0 @connection=#<Beekeeper::Connection:0x005627fdf27e18 @url="http://172.17.0.1:3001", @access_id="1337", @options={}>, @id="e2c6cc965839990268fc341c035964698afa5153ad4bee24a342cb8f0b17670f", @addresses={"3000/tcp"=>"0.0.0.0:32827"}, @last_status="running">]

Beekeeper::Bee.delete('46f8bdb4c0ba5a6aa396d01c48e4a765d9ab5d3057651e11705e544aceb8892e')
=> "deleted"

Beekeeper::Bee.all
=> [#<Beekeeper::Bee:0x005627fe209f78 @connection=#<Beekeeper::Connection:0x005627fdf27e18 @url="http://172.17.0.1:3001", @access_id="1337", @options={}>, @id="b3c65fbc0b2c3a22d777b1c92bb55022dbd7dd6e5797461785327ba8de85f527", @addresses={"3000/tcp"=>"0.0.0.0:32830"}, @last_status="running">, #<Beekeeper::Bee:0x005627fe209ed8 @connection=#<Beekeeper::Connection:0x005627fdf27e18 @url="http://172.17.0.1:3001", @access_id="1337", @options={}>, @id="e565c79f704ce51390f4525450697e123c89486b8faa511c522ec14c34929a23", @addresses={"3000/tcp"=>"0.0.0.0:32829"}, @last_status="running">, #<Beekeeper::Bee:0x005627fe209e38 @connection=#<Beekeeper::Connection:0x005627fdf27e18 @url="http://172.17.0.1:3001", @access_id="1337", @options={}>, @id="104df6b88209b074c79b5a7fe85bd155c3e01e4300718b3080f082acfb091a7f", @addresses={"3000/tcp"=>"0.0.0.0:32828"}, @last_status="running">, #<Beekeeper::Bee:0x005627fe209d98 @connection=#<Beekeeper::Connection:0x005627fdf27e18 @url="http://172.17.0.1:3001", @access_id="1337", @options={}>, @id="e2c6cc965839990268fc341c035964698afa5153ad4bee24a342cb8f0b17670f", @addresses={"3000/tcp"=>"0.0.0.0:32827"}, @last_status="running">]
```

### Within Rails

Add an initializer file for Beekeeper-api:

`touch config/initializers/beekeeper.rb`

And write all Beekeeper-api configuration there, for example:

```ruby
# Configure Beekeeper connection
# Assuming that your Beekeeper instance is running on your localhost port 3000
Beekeeper.url = 'http://localhost:3000'

# Assuming that Beekeeper was launched with -e 1337_API_KEY=ALMOST_PASTED_IT
Beekeeper.access_id = 1337
Beekeeper.api_key = 'ALMOST_PASTED_IT'
```

Then add `require 'beekeeper'` whenever you want to use beekeeper-api.

Configuration
-------------

### Logger

Beekeeper-api use the default ruby logger, you can set it via:

```ruby
Beekeeper.logger = Logger.new(STDOUT)
```
