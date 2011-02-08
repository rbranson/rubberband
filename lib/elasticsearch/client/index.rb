require 'client/hits'

module ElasticSearch
  module Api
    module Index

      # document
      # type
      # index
      # id (optional)
      # op_type (optional)
      # timeout (optional)
      def index(document, options={})
        index, type, options = extract_required_scope(options)

        id = options.delete(:id)
        if @batch
          @batch << { :index => { :_index => index, :_type => type, :_id => id }}
          @batch << document
        else
          execute(:index, index, type, id, document, options)
        end
      end

      def get(id, options={})
        index, type, options = extract_required_scope(options)
        # index
        # type
        # id
        # fields
        
        execute(:get, index, type, id, options)
      end

      def delete(id, options={})
        index, type, options = extract_required_scope(options)

        if @batch
          @batch << { :delete => { :_index => index, :_type => type, :_id => id }}
        else
          execute(:delete, index, type, id, options)
        end
      end

      #df	 The default field to use when no field prefix is defined within the query.
      #analyzer	 The analyzer name to be used when analyzing the query string.
      #default_operator	 The default operator to be used, can be AND or OR. Defaults to OR.
      #explain	 For each hit, contain an explanation of how to scoring of the hits was computed.
      #fields	 The selective fields of the document to return for each hit (fields must be stored), comma delimited. Defaults to the internal _source field.
      #field	 Same as fields above, but each parameter contains a single field name to load. There can be several field parameters.
      #sort	 Sorting to perform. Can either be in the form of fieldName, or fieldName:reverse (for reverse sorting). The fieldName can either be an actual field within the document, or the special score name to indicate sorting based on scores. There can be several sort parameters (order is important).
      #from	 The starting from index of the hits to return. Defaults to 0.
      #size	 The number of hits to return. Defaults to 10.
      #search_type	 The type of the search operation to perform. Can be dfs_query_then_fetch, dfs_query_and_fetch, query_then_fetch, query_and_fetch. Defaults to query_then_fetch.
      #scroll Get a scroll id to continue paging through the search results. Value is the time to keep a scroll request around, e.g. 5m
      #ids_only Return ids instead of hits
      def search(query, options={})
        index, type, options = extract_scope(options)

        execute(:search, index, type, query, options)
      end

      #ids_only Return ids instead of hits
      def scroll(scroll_id, options={})
        execute(:scroll, scroll_id)
      end 

      #df	 The default field to use when no field prefix is defined within the query.
      #analyzer	 The analyzer name to be used when analyzing the query string.
      #default_operator	 The default operator to be used, can be AND or OR. Defaults to OR.
      def count(query, options={})
        index, type, options = extract_scope(options)

        execute(:count, index, type, query, options)
      end

      # Starts a bulk operation batch and yields self. Index and delete requests will be 
      # queued until the block closes, then sent as a single _bulk call.
      def bulk
        @batch = []
        yield(self)
        response = execute(:bulk, @batch)
      ensure
        @batch = nil
      end

    end
  end
end
