# frozen_string_literal: true

require_relative "lib/powershell-pro-obfuscator/version"

Gem::Specification.new do |spec|
  spec.name = "powershell-pro-obfuscator"
  spec.version = PowerShellProObfuscator::VERSION
  spec.authors = ["Bartosz Wójcik"]
  spec.email = ["support@pelock.com"]
  spec.summary = "PowerShell Pro Obfuscator Web API Ruby SDK"
  spec.homepage = "https://www.pelock.com/products/powershell-pro-obfuscator"
  spec.license = "Apache-2.0"
  spec.required_ruby_version = ">= 2.7.0"
  spec.files = Dir["lib/**/*", "LICENSE", "README.md"]
  spec.require_paths = ["lib"]
  spec.metadata = {
    "homepage_uri" => spec.homepage,
    "source_code_uri" => "https://github.com/PELock/PowerShell-Pro-Obfuscator-Ruby",
    "bug_tracker_uri" => "https://www.pelock.com"
  }
end
