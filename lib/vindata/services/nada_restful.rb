require 'vindata/services/base'

module VinData::Services
  class NadaRestful < Base

    def initialize
      # get_token
    end

    def name
      'NADA RESTFUL'
    end

    def base_url
      base_url = configuration.dig(:nada_restful, :api_url)
      raise 'You missed to set nada_restful api url' unless base_url
      base_url
    end

    def get_client(valuationservice)
      url = base_url + valuationservice
      RestClient::Resource.new(url,
                               verify_ssl: false)
    end

    def headers
      {
        api_key: configuration[:nada_restful][:api_key],
      }
    end

    # Required Data:
    #   :vin
    #   :state
    def get_acv(data)
      return nil unless data[:vin] && data[:state]
      tries = 2

      client = get_client('defaultVehicleAndValuesByVin')
      region_id = data.fetch(:region, get_region_id_by_state( data[:state] ) )
      payload = {
        params: {
          period: 0,
          vin: data[:vin],
          region: region_id,
          mileage: data[:mileage]
        }
      }.merge(headers)

      begin
        response = client.get(payload)
        JSON.parse(response)['result'][0]
      rescue RestClient::Exception => error
        retry if (tries -= 1) > 0
        raise vindata_exception(error)
      end
    end

    def vindata_exception
      "VinData::#{error.class}"
    end

    def get_region_id_by_state(state_code)
      client  = get_client('regionIdByStateCode')
      payload = { params: { statecode: state_code} }
      payload = payload.merge(headers)
      begin
        JSON.parse( client.get(payload) )['result'][0]['regionid']
      rescue RestClient::Exception => error
        retry if (tries -= 1) > 0
        raise vindata_exception(error)
      end
    end

  end
end
