module Cmr
  class CmrClient < BaseClient
    def get_collections(options={}, token=nil)
      if Rails.env.development? || Rails.env.test?
        url = 'http://localhost:3003/collections.umm-json'
      else
        url = '/search/collections.umm-json'
      end
      get(url, options, token_header(token))
    end

    def get_providers
      if Rails.env.development? || Rails.env.test?
        url = 'http://localhost:3002/providers'
      else
        url = '/ingest/providers'
      end
      response = Rails.cache.fetch('get_providers', expires_in: 1.hours) do
        get(url)
      end
      response
    end

    def get_provider_holdings(provider_id = nil, token=nil)
      if Rails.env.development? || Rails.env.test?
        url = 'http://localhost:3003/provider_holdings.json'
      else
        url = '/search/provider_holdings.json'
      end

      options = {}
      options[:provider_id] = provider_id if provider_id

      response = Rails.cache.fetch("get_provider_holdings_#{provider_id || 'all'}", expires_in: 1.hours) do
        get(url, options, token_header(token))
      end
      response
    end

    def get_science_keywords
      if Rails.env.development? || Rails.env.test?
        url = 'http://localhost:3003/keywords/science_keywords'
      else
        url = '/search/keywords/science_keywords'
      end
      get(url).body
    end

    def get_temporal_keywords
      if Rails.env.development? || Rails.env.test?
        url = 'http://localhost:3003/keywords/temporal_keywords'
      else
        url = '/search/keywords/temporal_keywords'
      end
      get(url).body
    end

    def get_spatial_keywords
      if Rails.env.development? || Rails.env.test?
        url = 'http://localhost:3003/keywords/spatial_keywords'
      else
        url = '/search/keywords/spatial_keywords'
      end
      get(url).body
    end

    def translate_collection(draft_metadata, from_format, to_format, skip_validation = false)
      if Rails.env.development? || Rails.env.test?
        url = 'http://localhost:3002/translate/collection'
      else
        url = '/ingest/translate/collection'
      end
      url += '?skip_umm_validation=true' if skip_validation

      headers = {
        'Content-Type' => from_format,
        'Accept' => to_format
      }
      post(url, draft_metadata, headers)
    end

    def ingest_collection(metadata, provider_id, native_id, token)
      if Rails.env.development? || Rails.env.test?
        url = "http://localhost:3002/providers/#{provider_id}/collections/#{native_id}"
      else
        url = "/ingest/providers/#{provider_id}/collections/#{native_id}"
      end
      headers = {
        'Content-Type' => 'application/iso19115+xml'
      }
      put(url, metadata, headers.merge(token_header(token)))
    end

    def get_concept(concept_id, token, revision_id = nil)
      if Rails.env.development? || Rails.env.test?
        url = "http://localhost:3003/concepts/#{concept_id}#{'/' + revision_id if revision_id}"
      else
        url = "/search/concepts/#{concept_id}#{'/' + revision_id if revision_id}"
      end
      get(url, {}, token_header(token)).body
    end

    def delete_collection(provider_id, native_id, token)
      if Rails.env.development? || Rails.env.test?
        url = "http://localhost:3002/providers/#{provider_id}/collections/#{native_id}"
      else
        url = "/ingest/providers/#{provider_id}/collections/#{native_id}"
      end
      headers = {
        'Accept' => 'application/json'
      }
      delete(url, {}, headers.merge(token_header(token)))
    end

    # This method will be replaced by the work from CMR-2053, including granule counts in umm-json searches
    def get_granule_count(collection_id, token)
      if Rails.env.development? || Rails.env.test?
        url = 'http://localhost:3003/collections.json'
      else
        url = '/search/collections.json'
      end
      options = {
        concept_id: collection_id,
        include_granule_counts: true
      }
      get(url, options, token_header(token)).body['feed']['entry'].first
    end
  end
end
