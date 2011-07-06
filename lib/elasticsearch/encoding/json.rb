require "rufus-json"
require "json"

module ElasticSearch
  module Encoding
    class JSON < Base
      def initialize(*args)
        Rufus::Json.detect_backend
        super(*args)
      end
      
      def encode(object)
        Rufus::Json.encode(object)
      end

      def decode(string)
        Rufus::Json.decode(string)
      end

      def is_encoded?(object)
        object.is_a?(String)
      end
    end
  end
end
