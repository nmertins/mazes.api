require "http"
require "json"

module MazesApi
  class MazesServer
    def initialize
      @server = HTTP::Server.new([
        HTTP::ErrorHandler.new,
        HTTP::LogHandler.new,
        MazesHandler.new
      ])
      
      @server.bind_tcp "0.0.0.0", 8080
    end

    def listen
      @server.listen
    end
  end

  class MazesHandler
    include HTTP::Handler
    
    def call(context)
      case context.request.path
      when "/"
        response = context.response

        response.status = HTTP::Status::OK
        response.content_type = "application/json"
        
        body = JSON.build do |json|
          json.object do
            json.field("message", "You hit the base URI")
          end
        end

        response.output << body
      when "/foo"
        response = context.response

        response.status = HTTP::Status::OK
        response.content_type = "application/json"
        
        body = JSON.build do |json|
          json.object do
            json.field("message", "bar")
          end
        end

        response.output << body
      else
        context.response.status = HTTP::Status::NOT_IMPLEMENTED
      end

      context.response.close
      call_next(context)
    end
  end
end