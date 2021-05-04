require "http"
require "json"
require "./mazes_handler.cr"

module MazesApi
  class MazesServer
    def initialize
      @server = HTTP::Server.new([
        HTTP::ErrorHandler.new,
        HTTP::LogHandler.new,
        TopLevelHandler.new,
        MazesHandler.new
      ])
      
      @server.bind_tcp "0.0.0.0", 8080
    end

    def listen
      @server.listen
    end
  end

  class TopLevelHandler
    include HTTP::Handler
    
    def call(context)
      case context.request.path
      when "/"
        response = context.response

        response.status = HTTP::Status::OK
        response.content_type = "application/json"
        
        body = JSON.build do |json|
          json.object do
            json.field("message", "Welcome to mazes.cr!")
          end
        end

        response.output << body
        response.close

      when "/favicon.ico"
        response = context.response

        response.status = HTTP::Status::OK
        response.content_type = "image/x-icon"
        
        body = File.read("resources/favicon.ico")

        response.output << body
        response.close

      end

      call_next(context)
    end
  end
end