# frozen_string_literal: true

###############################################################################
#
# PowerShell Pro Obfuscator WebApi interface usage example.
#
# In this example we will obfuscate sample source with default options.
#
# Version        : v1.0.0
# Language       : Ruby
# Author         : Bartosz Wójcik
# Web page       : https://www.pelock.com
#
###############################################################################

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "powershell-pro-obfuscator"

client = PowerShellProObfuscator.new("ABCD-ABCD-ABCD-ABCD")

source = <<~PS
  function Get-Greeting {
      param([string]$Name)
      Write-Host "Hello World from $Name!"
  }
  Get-Greeting "PowerShell Pro Obfuscator"
PS

result = client.obfuscate_script_source(source)
if result && result["error"] == PowerShellProObfuscator::ERROR_SUCCESS
  puts result["output"]
else
  warn "An error occurred, error code: #{result && result['error']}"
end
