# External gems
require 'rest_client'

# Internal files
require 'vindata/configuration'
require 'vindata/services'

module VinData
  def self.details_by_vin vin, service = config[:service]
    service = Services.get service
    service.details_by_vin vin
  end

  def self.get_acv data, service = config[:service]
    service = Services.get service
    service.get_acv data
  end

  def self.recalls data, service = config[:service]
    service = Services.get service
    service.recalls data
  end

  def self.get_acv_rest(data, service = config[:service])
    service = Services.get service
    service.get_acv data
  end

  def self.get_region_by_state(state_code, service = config[:service])
    service = Services.get service
    service.get_region_id_by_state state_code
  end
end
