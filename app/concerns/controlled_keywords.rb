# :nodoc:
module ControlledKeywords
  extend ActiveSupport::Concern

  def get_controlled_keyword_short_names(keywords)
    keywords.map do |keyword|
      values = []
      keyword.fetch('subfields', []).each do |subfield|
        values += if subfield == 'short_name'
                    keyword.fetch('short_name', []).map do |short_name|
                      url = short_name.fetch('url', [{}]).first['value'] || short_name.fetch('long_name', [{}]).first.fetch('url', [{}]).first['value']

                      {
                        short_name: short_name['value'],
                        long_name: short_name.fetch('long_name', [{}]).first['value'],
                        url: url
                      }
                    end
                  else
                    get_controlled_keyword_short_names(keyword.fetch(subfield, []))
                  end
      end
      values.flatten
    end
  end

  def fetch_science_keywords
    response = cmr_client.get_controlled_keywords('science_keywords')
    if response.success?
      response.body
    else
      []
    end
  end

  def set_science_keywords
    keywords = fetch_science_keywords
    if keywords.key? 'category'
      keywords['category'].each do |category|
        if category['value'] == 'EARTH SCIENCE SERVICES'
          keywords['category'].delete(category)
          break
        end
      end
    end
    @science_keywords = keywords
  end

  def set_service_keywords
    keywords = fetch_science_keywords
    if keywords.key? 'category'
      keywords['category'].each do |category|
        if category['value'] == 'EARTH SCIENCE'
          keywords['category'].delete(category)
          break
        end
      end
    end
    @service_keywords = keywords
  end

  def set_location_keywords
    response = cmr_client.get_controlled_keywords('spatial_keywords')
    @location_keywords = if response.success?
                           response.body
                         else
                           []
                         end
  end

  def set_data_centers
    @data_centers = fetch_data_centers.map { |data_center| [data_center.fetch(:short_name, ''), data_center.fetch(:short_name, ''), { 'data-long-name' => data_center[:long_name], 'data-url' => data_center[:url] }] }
  end

  def fetch_data_centers
    response = cmr_client.get_controlled_keywords('data_centers')

    if response.success?
      data_centers = get_controlled_keyword_short_names(response.body.fetch('level_0', []))

      data_centers.flatten.sort_by { |a| a[:short_name] }
    else
      []
    end
  end

  def set_platform_types
    @platform_types = fetch_platforms.map { |platform| [platform[:type], platform[:short_names].map { |sn| [sn[:short_name], 'data-long-name' => sn[:long_name], 'data-type' => platform[:type]] }] }
  end

  def set_platform_short_names
    @platform_short_names = fetch_platforms.map { |type| type[:short_names].map { |short_name| short_name[:short_name] } }.flatten
  end

  def fetch_platforms
    response = cmr_client.get_controlled_keywords('platforms')

    # sets platform types with nested short_name and long_name values
    if response.success?
      platform_types = response.body.fetch('category', []).map do |category|
        short_names = get_controlled_keyword_short_names(Array.wrap(category))

        {
          type: category['value'],
          short_names: short_names.flatten.sort_by { |a| a[:short_name] }
        }
      end
      platform_types.sort_by { |a| a[:type] }
    else
      []
    end
  end

  def set_instruments
    @instruments = fetch_instruments.map { |instrument| [instrument[:short_name], instrument[:short_name], { 'data-long-name' => instrument[:long_name] }] }
  end

  def set_instrument_short_names
    @instrument_short_names = fetch_instruments.map { |short_name| short_name[:short_name] }.flatten
  end

  def fetch_instruments
    response = cmr_client.get_controlled_keywords('instruments')
    if response.success?
      instruments = get_controlled_keyword_short_names(response.body.fetch('category', []))

      instruments.flatten.sort_by { |a| a[:short_name] }
    else
      []
    end
  end

  def set_projects
    response = cmr_client.get_controlled_keywords('projects')
    @projects = if response.success?
                  projects = response.body.fetch('short_name', []).map do |short_name|
                    {
                      short_name: short_name['value'],
                      long_name: short_name.fetch('long_name', [{}]).first['value']
                    }
                  end
                  projects.sort { |a, b| a[:short_name] <=> b[:short_name] }
                else
                  []
                end
  end

  def set_temporal_keywords
    response = cmr_client.get_controlled_keywords('temporal_keywords')
    @temporal_keywords = if response.success?
                           keywords = response.body.fetch('temporal_resolution_range', [])

                           keywords.map { |keyword| keyword['value'] }.sort
                         else
                           []
                         end
  end

  def set_country_codes
    # put the US at the top of the country list
    country_codes = Carmen::Country.all.sort
    united_states = country_codes.delete(Carmen::Country.named('United States'))
    @country_codes = country_codes.unshift(united_states)
  end
end
