require "./server/*"

# TODO: Write documentation for `MazesApp`
module MazesApi
  VERSION = "0.1.0"

  server = MazesServer.new
  server.listen
end
