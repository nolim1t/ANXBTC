# nl-anx
[![Gem Version](https://badge.fury.io/rb/nl-anx.svg)](https://badge.fury.io/rb/nl-anx)

## About
ANXBTC is a Ruby Library for interfacing with the ANXBTC.com API.

This class lets you do market queries and trading (if you allow it from the control panel)

## Environment Variables
* anx_access_key
* anx_access_secret

## Usage:
This will change

* gem install httparty
* gem install nl-anx
* Set up environment variables

## Example code
```ruby
require "nl-anx"
a = ANX.new
puts a.BTCHKD_money_depth_full
```
