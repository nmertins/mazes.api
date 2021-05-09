require "http"
require "json"
require "mazes.cr/src/mazes/*"

module MazesApi
  class MazesHandler
    include HTTP::Handler

    def call(context)
      request = context.request

      case request.path
      when "/v1/mazes"
        params = request.query_params
        size = params.has_key?("size") ? params["size"].to_i : 10

        grid = Mazes::Grid.new(size, size)
        Mazes::Sidewinder.on(grid)
        
        response = context.response

        response.status = HTTP::Status::OK
        response.content_type = "application/json"
        
        grid.to_json(response.output)

        response.close

      end

      call_next(context)
    end
  end
end