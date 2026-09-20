# PowerShell Pro Obfuscator — Ruby Web API SDK

Ruby SDK for [PowerShell Pro Obfuscator](https://www.pelock.com/products/powershell-pro-obfuscator).

API documentation: https://www.pelock.com/products/powershell-pro-obfuscator/api

Endpoint: `https://www.pelock.com/api/powershell-pro-obfuscator/v1`

## Installation

```bash
gem install powershell-pro-obfuscator
```

Or add to your Gemfile:

```ruby
gem "powershell-pro-obfuscator"
```

Uses Ruby stdlib `Net::HTTP` only.

## Usage

```ruby
require "powershell-pro-obfuscator"

client = PowerShellProObfuscator.new("YOUR-WEB-API-KEY")
result = client.obfuscate_script_source('Write-Host "Hello"')
puts result["output"] if result && result["error"] == PowerShellProObfuscator::ERROR_SUCCESS
```

All obfuscation strategies default to enabled. Optional zlib compression is off by default.

See `examples/`.

## License

Apache-2.0. Copyright Bartosz Wójcik / PELock.
