# frozen_string_literal: true

###############################################################################
#
# PowerShell Pro Obfuscator WebApi interface usage example.
#
# In this example we will verify our activation key status.
#
# Version        : v1.0.0
# Language       : Ruby
# Author         : Bartosz Wójcik
# Web page       : https://www.pelock.com
#
###############################################################################

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "powershell-pro-obfuscator"

result = PowerShellProObfuscator.new("ABCD-ABCD-ABCD-ABCD").login
if result
  puts "Demo version status - #{result['demo']}"
  puts "Usage credits left - #{result['credits_left']}"
  puts "Total usage credits - #{result['credits_total']}"
  puts "Max. source code size - #{result['string_limit']}"
else
  warn "Something unexpected happen while trying to login to the service."
end
