# frozen_string_literal: true

require "base64"
require "json"
require "zlib"

class PowerShellProObfuscator
  API_URL = "https://www.pelock.com/api/powershell-pro-obfuscator/v1"
  ERROR_SUCCESS = 0
  ERROR_INPUT_SIZE = 1
  ERROR_INPUT = 2
  ERROR_PARSING = 3
  ERROR_OBFUSCATION = 4
  ERROR_OUTPUT = 5
  USER_AGENT = "PELock PowerShell Pro Obfuscator"

  FLAG_PARAMS = {
    self_defending: "self_defending",
    protection_linker: "protection_linker",
    rename_variables: "rename_variables",
    rename_parameters: "rename_parameters",
    rename_functions: "rename_functions",
    shuffle_functions: "shuffle_functions",
    control_flow_flatten: "control_flow_flatten",
    state_machine: "state_machine",
    vm_strategy: "vm_strategy",
    encrypt_integers: "encrypt_integers",
    split_strings: "split_strings",
    encrypt_strings: "encrypt_strings",
    integers_to_arrays: "integers_to_arrays",
    floats_to_arrays: "floats_to_arrays",
    insert_dead_code: "insert_dead_code",
    complexify_booleans: "complexify_booleans",
    integers_to_floating: "integers_to_floating",
    encrypt_floating: "encrypt_floating",
    decoy_functions: "decoy_functions",
    detect_debugger: "detect_debugger",
    fake_dot_source_markers: "fake_dot_source_markers",
    opaque_branches: "opaque_branches",
    scriptblock_decoys: "scriptblock_decoys",
    literal_padding: "literal_padding",
    reflect_invoke_commands: "reflect_invoke_commands",
    string_char_array_vault: "string_char_array_vault",
    try_finally_noise: "try_finally_noise",
    affine_integer_mask: "affine_integer_mask",
    event_stub: "event_stub",
    remove_comments: "remove_comments"
  }.freeze

  attr_accessor :enable_compression, *FLAG_PARAMS.keys

  def initialize(api_key = nil)
    @api_key = api_key
    @enable_compression = false
    FLAG_PARAMS.each_key { |name| instance_variable_set("@#{name}", true) }
  end

  def login(return_as_object = true)
    post_request({ "command" => "login" }, return_as_object)
  end

  def obfuscate_script_file(script_file_path, return_as_object = true)
    source = File.read(script_file_path, encoding: "UTF-8")
    return nil if source.nil? || source.empty?

    obfuscate_script_source(source, return_as_object)
  rescue StandardError
    nil
  end

  def obfuscate_script_source(script_source, return_as_object = true)
    post_request({ "command" => "obfuscate", "source" => script_source }, return_as_object)
  end

  private

  def post_request(params_array, return_as_object)
    params = params_array.dup
    params["key"] = @api_key unless @api_key.nil? || @api_key.to_s.empty?

    FLAG_PARAMS.each do |name, key|
      params[key] = "1" if instance_variable_get("@#{name}")
    end

    if @enable_compression && params["source"]
      params["source"] = Base64.strict_encode64(Zlib::Deflate.deflate(params["source"], 9))
      params["compression"] = "1"
    end

    body = Http.post_multipart(API_URL, params, user_agent: USER_AGENT)
    return nil if body.nil? || body.empty?

    result = Http.parse_json(body)
    return nil if result.nil?

    depacked = false
    if @enable_compression && result["error"] == ERROR_SUCCESS && result["output"]
      begin
        result["output"] = Zlib::Inflate.inflate(Base64.decode64(result["output"]))
        depacked = true
      rescue StandardError
        return nil
      end
    end

    return result if return_as_object
    return JSON.generate(result) if depacked

    body
  end
end
