# ruby

[![Build Status](https://travis-ci.org/sweeperio/chef-ruby.svg?branch=master)](https://travis-ci.org/sweeperio/chef-ruby)

Installs precompiled rubies for faster converges.

## What This Does

* Installs one or more versions of ruby
* Designates one version as the system version (will be available in $PATH)
* Exposes the `ruby_version` LWRP that can used to install precompiled rubies for ubuntu 14.04
* Optionally, installs and configures [chruby](https://github.com/postmodern/chruby)

## Attributes

| attribute | description | default |
|-----------|-------------|---------|
| `node["ruby"]["install_dir"]` | where to install rubies | `/opt/rubies` |
| `node["ruby"]["versions"]` | which rubies to install | `%w(2.2.3)` |
| `node["ruby"]["sources"]` | hash of `version => compiled package url` | See _attributes/default.rb_ |
| `node["ruby"]["system_version"]` | The version to be symlinked in `/usr/local/bin` | `2.2.3` |
| `node["chruby"]["version"]` | the version of chruby to install | `0.3.9` |
| `node["chruby"]["auto_switch"]` | whether or not to support [auto switching] | `true` |

[auto switching]: https://github.com/postmodern/chruby#auto-switching

## Recipes

### ruby::default

Installs all versions defined in `node["ruby"]["versions"]` and symlinks all the `bin/*` files in the version defined in
`node["ruby"]["system_versions"]` as `/usr/local/bin/<executable>`.

This recipe _**does not**_ include the `chruby` recipe since that is an optional addon we don't need/want on most
machines.

**Usage**: add `recipe[ruby]` to your run list

### ruby::chruby

Installs the version of chruby defined in `node["chruby"]["version"]` and optionally configures [auto switching] based
on `node["chruby"]["auto_switch"]`.

This recipe also creates `/etc/profile.d/chruby.sh` which will be loaded by interactive shells by default. The system
version will be set as the default.

**Usage**: add `recipe[ruby::chruby]` to your run list

## Resources

### ruby_version

Installs a precompiled version of ruby in `node["ruby"]["install_dir"]`.

#### Properties

| property | description | value |
|----------|-------------|-------|
| version | The version to install | The name of the resource |
| symlink | whether or not to symlink this version (make system version) | Default: `false` |

**Usage**

```ruby
# in a recipe or resource...
ruby_version("2.1.8")

ruby_version "2.2.3" do
  symlink true
end
```
