<img align="left" src="https://dl.dropboxusercontent.com/u/11845683/Assets/ec-logo-no-text-small.png"></img>

Elasticonf [![Build Status](https://travis-ci.org/rezwyi/elasticonf.svg?branch=master)](https://travis-ci.org/rezwyi/elasticonf) [![Dependency Status](https://gemnasium.com/rezwyi/elasticonf.svg)](https://gemnasium.com/rezwyi/elasticonf) [![Coverage Status](https://img.shields.io/coveralls/rezwyi/elasticonf.svg)](https://coveralls.io/r/rezwyi/elasticonf)
==========

<br />

Powerfull and flexible application config solution worked in any ruby program. No clases definition, no dependencies. It just works!

## Installation

First add the following lines to your application `Gemfile`:

``` ruby
gem 'elasticonf', '~> 1.1.3'
```

Then run `bundle install` to update your's gems bundle.

## Setup and usage

For basic setup you must pass a block to `Elasticonf.configure` method and call `Elasticonf.load!`.

To load settings from the file `some/path/settings.yml` and define `Settings` constant, you need to run the following code:

```ruby
require 'elasticonf'

Elasticonf.configure do |config|
  config.config_root = 'some/path'
end

Elasticonf.load!
puts Settings.some_key # will print some value
```

To load settings from the file `some/path/config.yml` and define `Config` constant, you need:

```ruby
require 'elasticonf'

Elasticonf.configure do |config|
  config.config_root = 'some/path'
  config.config_file = 'config'
  config.constant_name = 'Config'
end

Elasticonf.load!
puts Config.some_key # will print some value
```

There is also support for multi environment. To do this change the value of the `config.env` (the default is `'development'`).

Elasticonf supports the following priorities of files (the priority decreases from top to bottom). For the default configuration:

0. `#{Elasticonf.config_root}/settings.local.yml`
0. `#{Elasticonf.config_root}/settings/development.yml`
0. `#{Elasticonf.config_root}/settings.yml`

Sometimes there can be a situation when the constant defined Elasticonf already exists. In this case, exception will raise and method execution will stop. To change this behavior you need to set `config.raise_if_already_initialized_constant` to `false`. Take a look:

```ruby
require 'elasticonf'

Settings = "I'm predefined constant!"

Elasticonf.configure do |config|
  config.config_root = 'some/path'
end

Elasticonf.load! # will raise RuntimeError "Cannot set constant Settings because it is already initialized"
```

However, this code is okay:

```ruby
require 'elasticonf'

Settings = "I'm predefined constant!"

Elasticonf.configure do |config|
  config.config_root = 'some/path'
  config.raise_if_already_initialized_constant = false
end

Elasticonf.load! # will not raise any error
puts Settings.some_key # will print some value
```

## Documentation

Run this commands in terminal:

0. `cd path/to/elasticonf/repo`
0. `bin/yard server`
0. Go to [http://localhost:8808](http://localhost:8808) (by default) in your favorite browser

## Testing

Run this commands in terminal:

0. `cd some/path`
0. `git clone git@github.com:rezwyi/elasticonf.git`
0. `cd elasticonf/`
0. `bundle install`
0. `bin/rake`

## Versioning

Elasticonf uses RubyGems Rational Versioning Policy.

## Copyright

See LICENSE file.