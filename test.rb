require_relative 'app'
require 'stringio'

reply = Sinatra::Application.call 'PATH_INFO' => '/pjackson28', 'REQUEST_METHOD' => 'GET', 'rack.input' => StringIO.new
puts "TEST: User has pull requests to other repos: "
fail "wrong status code" if reply.first != 200
fail "wrong result" if JSON.parse(reply.last.first)['data'] == []
puts "--------> success"

reply = Sinatra::Application.call 'PATH_INFO' => '/kamelury', 'REQUEST_METHOD' => 'GET', 'rack.input' => StringIO.new
puts "TEST: User has no pull requests to other repos: "
fail "wrong status code" if reply.first != 200
fail "wrong result" if JSON.parse(reply.last.first)['data'] != []
puts "--------> success"

reply = Sinatra::Application.call 'PATH_INFO' => '/', 'REQUEST_METHOD' => 'GET', 'rack.input' => StringIO.new
puts "TEST: No username passed: "
fail "wrong status code" if reply.first != 404
puts "--------> success"

reply = Sinatra::Application.call 'PATH_INFO' => '/zmncvbskfgeai', 'REQUEST_METHOD' => 'GET', 'rack.input' => StringIO.new
puts "TEST: Username doesn't exsist: "
fail "wrong status code" if JSON.parse(reply.last.first)['code'] != "404"
puts "--------> success"