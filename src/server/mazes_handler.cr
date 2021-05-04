require "http"
require "json"
require "mazes.cr"

module MazesApi
  class MazesHandler
    include HTTP::Handler

    def call(context)
      case context.request.path
      when "/v1/mazes"
        response = context.response

        response.status = HTTP::Status::OK
        response.content_type = "application/json"
        
        grid = Mazes::Grid.new(10, 10)
        Mazes::Sidewinder.on(grid)

        grid.to_json(response.output)

        response.close

      end

      call_next(context)
    end
  end
end