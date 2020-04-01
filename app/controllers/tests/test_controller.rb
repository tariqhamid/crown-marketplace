module Tests
  class TestController < FacilitiesManagement::FrameworkController
    ## skip_before_action :authenticate_user!
    # skip_before_action :authorize_user
    skip_before_action :verify_authenticity_token, only: [:index]

    respond_to :html, :json

    def index
      # params.permit!

      calculate params if params['gia']

      render layout: false
    end

    private

    # rubocop:disable Metrics/AbcSize
    def calculate(vals)
      id = SecureRandom.uuid

      # start_date = Time.zone.today + 1
      # e.g. DateTime.strptime('2011-03-09',"%Y-%m-%d")
      start_date = DateTime.strptime(vals['startdate'], '%Y-%m-%d')

      data2 =
        {
          start_date: start_date,
          'is-tupe': vals['tupe'] ? 'yes' : 'no',
          'fm-contract-length': vals['contract-length']
        }
      data2[:posted_locations] = vals.keys.select { |k| k.start_with?('region-') }.collect { |k| vals[k] }

      b =
        {
          'id' => id,
          'gia' => vals['gia'].to_f,
          'isLondon' => vals['isLondon'] ? 'Yes' : 'No',
          'fm-building-type' => 'General office - Customer Facing'
        }

      all_buildings =
        [
          OpenStruct.new(building_json: b)
        ]

      posted_services = vals.keys.select { |k| k.start_with?('service-') }.collect { |k| vals[k] }

      uom_vals = []
      posted_services.each do |s|
        uom_vals <<
          {
            user_id: 'dGVzdEBleGFtcGxlLmNvbQ==\n',
            service_code: s,
            uom_value: vals['uom-' + s],
            building_id: id,
          }
      end

      @report = FacilitiesManagement::SummaryReport.new(start_date: start_date, user_email: 'test@example.com', data: data2)

      @results = {}
      supplier_names = CCS::FM::RateCard.latest.data[:Prices].keys
      supplier_names.each do |supplier_name|
        # dummy_supplier_name = 'Hickle-Schinner'
        @report.calculate_services_for_buildings all_buildings, uom_vals, supplier_name
        @results[supplier_name] = @report.direct_award_value
      end

      # p @results
    end
    # rubocop:enable Metrics/AbcSize
  end
end