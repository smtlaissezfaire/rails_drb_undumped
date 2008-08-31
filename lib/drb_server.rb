require File.dirname(__FILE__) + "/../config/environment"

require "colored"
require 'drb'
here = 'druby://127.0.0.1:10000'
connection = User.connection
connection.extend DRb::DRbUndumped

def connection.select(sql, name = nil)
  puts "* Executing SQL: " + "#{sql}".red
  @connection.query_with_result = true
  result = execute(sql, name)
  rows = result.all_hashes
  result.free
  rows.extend DRb::DRbUndumped
  rows
end

DRb.start_service here, connection
puts '* Waiting for connections'
DRb.thread.join
