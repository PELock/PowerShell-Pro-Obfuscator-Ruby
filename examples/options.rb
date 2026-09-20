# frozen_string_literal: true

###############################################################################
#
# PowerShell Pro Obfuscator WebApi interface usage example.
#
# In this example we will obfuscate sample source with custom options.
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

# should the source code be compressed (both input & compressed)
client.enable_compression = false

#
# global obfuscation options
#
# you can disable a particular obfuscation strategy globally if it
# fails or you don't want to use it without modifying the source codes
#
# by default all obfuscation strategies are enabled
#

# protection against tampering with protected code (integrity verification)
client.self_defending = true

# protection linker (decoy call graph)
client.protection_linker = true

# rename variable names to random string values
client.rename_variables = true

# rename parameter names to random string values
client.rename_parameters = true

# rename function names to random string values
client.rename_functions = true

# shuffle function order in the output source
client.shuffle_functions = true

# change linear code execution flow via control-flow flattening
client.control_flow_flatten = true

# rewrite statement blocks into finite-state automata (state-machine obfuscation)
client.state_machine = true

# lift selected statements into a VM engine (virtualized statements)
client.vm_strategy = true

# encrypt integers
client.encrypt_integers = true

# split strings into concatenated chunks
client.split_strings = true

# encrypt strings using randomly generated polymorphic encryption algorithms
client.encrypt_strings = true

# move integers to arrays
client.integers_to_arrays = true

# move floats to arrays
client.floats_to_arrays = true

# insert dead code
client.insert_dead_code = true

# replace boolean conditions with equivalent complex expressions
client.complexify_booleans = true

# represent integers via floating-point math
client.integers_to_floating = true

# encrypt floating point numbers
client.encrypt_floating = true

# insert decoy functions
client.decoy_functions = true

# insert anti-debugging detections
client.detect_debugger = true

# insert fake dot-source comment markers
client.fake_dot_source_markers = true

# insert opaque predicate branches
client.opaque_branches = true

# insert scriptblock decoys
client.scriptblock_decoys = true

# insert here-string padding
client.literal_padding = true

# use indirect command invocation
client.reflect_invoke_commands = true

# store string fragments in char-code array vaults
client.string_char_array_vault = true

# wrap code in try/finally blocks with dead noise
client.try_finally_noise = true

# apply redundant xor / affine integer masks
client.affine_integer_mask = true

# insert dead event/timer stubs
client.event_stub = true

# strip comments from the output source
client.remove_comments = true

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
