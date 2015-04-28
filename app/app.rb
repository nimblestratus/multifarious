require 'rubygems'
require 'sinatra'
require 'sinatra/json'
require 'redis'
require 'json'
require 'rbconfig'


# get the architecture
# On a Pi2 it is "arm7l-linux-eabihf"
# On a PC is it "x86_64-linux"
# 
# All I really care about is the x86_64 or the arm7l piece
#
# I don't have a mac to test
# I don't have a box booted into Windows at the moment either
ARCH = RbConfig::CONFIG['arch'].split("-").first


redis = Redis.new()             # settings picked up from REDIS_URL ENV variable

set :port, 80

# Powerstrip will send something like this:
# {
#     PowerstripProtocolVersion: 1,
#     Type: "pre-hook",
#     ClientRequest: {
#         Method: "POST",
#         Request: "/v1.16/container/create",
#         Body: "{ ... }" or null
#     }
# }

POST '/' do
  args = JSON.parse(request.body.read)
  image = args["ClientRequest"]["Body"]["Image"]
  args["ModifiedClientRequest"] = args["ClientRequest"]
  args.delete("ClientRequest")
  new_img = redis.hget("multifarious:#{image}", ARCH)
  args["ModifiedClientRequest"]["Body"]["Image"] = new_img unless new_img.nil?
  json(args)
end
