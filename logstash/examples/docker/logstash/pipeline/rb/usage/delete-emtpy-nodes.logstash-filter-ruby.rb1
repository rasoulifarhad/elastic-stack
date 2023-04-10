###############################################################################
# delete-emtpy-nodes.logstash-filter-ruby.rb
# ---------------------------------
# A script for a Logstash Ruby Filter to delete empty nodes from an event; by
# default, crawls the entire event recursively, but it can be configured to
# limit the scope.
###############################################################################
#
# Copyright 2018 Ry Biesemeyer
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
def register(params)
  params = params.dup

  # source: if provided, only the hash at the provided field reference will be walked
  #         (default: entire event)
  @source = params.delete('source')

  # recursive: set to `false` to avoid recusrive walking of deeply-nested hashes and arrays
  #            (default: true)
  @recursive = params.delete('recursive')
  @recursive = case @recursive && @recursive.downcase
               when nil, true,  'true'  then true
               when      false, 'false' then false
               else report_configuration_error("script parameter `recursive` must be either `true` or `false`; got `#{@recursive}`.")
               end

  params.empty? || report_configuration_error("unknown script parameter(s): #{params.keys}.")
end

def report_configuration_error(message)
  raise LogStash::ConfigurationError, message
end

def filter(event)
  source_map = @source.nil? ? event.to_hash : event.get(@source)

  return [event] unless source_map

  fail('source not a key/value map') unless source_map.kind_of?(Hash)

  _walk(source_map, [@source].compact) do |field_reference, value|
    logger.trace("YIELDING(#{field_reference}) => `#{value.inspect}`") if logger.trace?

    event.remove(field_reference) if (value.nil?) ||
                                     (value.respond_to?(:empty?) && value.empty?)
  end

rescue => e
  logger.error('failed to remove empty field', exception: e.message)
  event.tag('_removeemptyerror')
ensure
  return [event]
end

##
# walks the provided hash, yielding the field reference and value for each leaf node
#
# @param element [Hash{String=>Object},Array[Object],Object]
# @param keypath [Array[String]]
#
# @yieldparam fieldreference [String]
# @yieldparam value [Object]
#
# @return [void]
def _walk(element, keypath=[], &blk)
  case
  when @recursive && element.kind_of?(Array) && !element.empty?
    element.each_with_index do |sub_element, sub_index|
      _walk(sub_element, keypath + [sub_index], &blk)
    end
  when @recursive && element.kind_of?(Hash) && !element.empty?
    element.each do |sub_key, sub_element|
      _walk(sub_element, keypath + [sub_key], &blk)
    end
  else
    yield(_build_field_reference(keypath), element)
  end
end

##
# builds a valid field reference from the provided components
def _build_field_reference(fragments)
  return fragments[0] if fragments.size == 1

  return "[#{fragments.join('][')}]"
end

test 'defaults' do
  parameters { Hash.new }

  in_event do
    {
      "int" => 1,
      "str" => "fubar",
      "array" => [
        {"int" => 12},
        {"str" => "foobar"},
        {"empty_hash" => {}},
        {"empty_array" => []}
      ],
      "hash" => {
        "int" => 123,
        "str" => "FUBAR",
        "empty_hash" => {},
        "empty_array" => [],
        "non-empty_hash" => {"a"=>"b"}
      }
    }
  end

  expect("produces single event") do |events|
    events.size == 1
  end

  expect('leaves string value in tact') do |events|
    events.first.include?("[hash][str]")
  end

  expect('leaves int value in tact') do |events|
    events.first.include?("[hash][int]")
  end

  expect("leaves non-empty hash in-tact") do |events|
    events.first.include?("[hash][non-empty_hash]")
  end

  expect("deletes empty hash") do |events|
    !events.first.include?("[hash][empty_hash]")
  end
end

test 'with source pointing at populated hash' do
  parameters { {'source' => '[hash]' } }

  in_event do
    {
      "int" => 1,
      "str" => "fubar",
      "array" => [
        {"int" => 12},
        {"str" => "foobar"},
        {"empty_hash" => {}},
        {"empty_array" => []}
      ],
      "hash" => {
        "int" => 123,
        "str" => "FUBAR",
        "empty_hash" => {},
        "empty_array" => [],
        "non-empty_hash" => {"a"=>"b"}
      },
      "empty_hash" => {},
      "empty_array" => []
    }
  end

  expect("produces single event") do |events|
    events.size == 1
  end

  expect('does not delete out-of-scope elements') do |events|
    events.first.include?('empty_hash')
  end

  expect('deletes emtpy hash in scope') do |events|
    !events.first.include?('[hash][empty_hash]')
  end

  expect('deletes emtpy array in scope') do |events|
    !events.first.include?('[hash][empty_array]')
  end
end


test 'with source pointing at populated hash and `recursive => false`' do
  parameters { {'source' => '[hash]', 'recursive' => 'false' } }

  in_event do
    {
      "int" => 1,
      "str" => "fubar",
      "array" => [
        {"int" => 12},
        {"str" => "foobar"},
        {"empty_hash" => {}},
        {"empty_array" => []}
      ],
      "hash" => {
        "int" => 123,
        "str" => "FUBAR",
        "empty_hash" => {},
        "empty_array" => [],
        "non-empty_hash" => {"a"=>"b"}
      },
      "empty_hash" => {},
      "empty_array" => []
    }
  end

  expect("produces single event") do |events|
    events.size == 1
  end

  expect('does not delete out-of-scope elements') do |events|
    events.first.include?('empty_hash')
  end

  expect('does not delete emtpy hash nested in scope') do |events|
    events.first.include?('[hash][empty_hash]')
  end

  expect('does not delete emtpy array nested in scope') do |events|
    events.first.include?('[hash][empty_array]')
  end
end


test 'with source pointing at empty hash and `recursive => false`' do
  parameters { {'source' => '[empty_hash]', 'recursive' => 'false' } }

  in_event do
    {
      "int" => 1,
      "str" => "fubar",
      "array" => [
        {"int" => 12},
        {"str" => "foobar"},
        {"empty_hash" => {}},
        {"empty_array" => []}
      ],
      "hash" => {
        "int" => 123,
        "str" => "FUBAR",
        "empty_hash" => {},
        "empty_array" => [],
        "non-empty_hash" => {"a"=>"b"}
      },
      "empty_hash" => {},
      "empty_array" => []
    }
  end

  expect("produces single event") do |events|
    events.size == 1
  end

  expect('deletes target element') do |events|
    !events.first.include?('empty_hash')
  end

  expect('does not delete emtpy hash nested out of scope') do |events|
    events.first.include?('[hash][empty_hash]')
  end

  expect('does not delete emtpy array nested out of scope') do |events|
    events.first.include?('[hash][empty_array]')
  end
end
