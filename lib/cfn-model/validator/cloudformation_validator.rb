require_relative 'schema_generator'
require 'kwalify'
require 'json'

class CloudFormationValidator
  def validate(cloudformation_string)
    if json_text?(cloudformation_string)
      raise ParserError.new('Invalid JSON!') unless valid_json?(cloudformation_string)
    end

    schema = SchemaGenerator.new.generate cloudformation_string
    validator = Kwalify::Validator.new(schema)
    validator.validate(YAML.load(cloudformation_string))
  end

  private

  def json_text?(cloudformation_string)
    first_character = cloudformation_string.gsub(/\s/, '').split('').first
    matches = cloudformation_string.scan(/\{[^}]*\}/)
    first_character == '{' && !matches.empty?
  end

  def valid_json?(cloudformation_string)
      JSON.parse(cloudformation_string)
      return true
  rescue JSON::ParserError => error
    return false
  end
end
