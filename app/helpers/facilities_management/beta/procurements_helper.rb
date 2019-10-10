module FacilitiesManagement::Beta::ProcurementsHelper
  def journey_step_url_former(journey_step:, region_codes: nil, service_codes: nil)
    "/facilities-management/choose-#{journey_step}?#{{ region_codes: region_codes }.to_query}&#{{ service_codes: service_codes }.to_query}"
  end

  def format_date(date_object)
    date_object.strftime '%d %B %Y'
  end

  def initial_call_off_period_start_date
    format_date @procurement.initial_call_off_start_date
  end

  def initial_call_off_period_end_date
    end_date = Date.parse(@procurement.initial_call_off_start_date.to_s).next_year(@procurement.initial_call_off_period) - 1
    format_date end_date
  end

  def mobilisation_period
    result = 'None'
    period = @procurement.mobilisation_period
    unless @procurement.mobilisation_period.nil?
      result = "#{period}  #{(period > 1 ? ' weeks' : 'week')}"
    end
    result
  end

  def mobilisation_start_date
    start_date = Date.parse(@procurement.initial_call_off_start_date.to_s) - (@procurement.mobilisation_period * 7)
    format_date start_date
  end

  def mobilisation_end_date
    end_date = Date.parse(@procurement.initial_call_off_start_date.to_s) - 1
    format_date end_date
  end

  def initial_call_off_period(period)
    period.to_s + (period > 1 ? ' years' : 'year')
  end

  def format_extension(start_date, end_date)
    "#{format_date start_date} to #{format_date end_date}"
  end

  def extension_one_description
    extension_one_start_date = @procurement.initial_call_off_start_date.next_year(@procurement.initial_call_off_period)
    extension_one_end_date = extension_one_start_date.next_year(@procurement.optional_call_off_extensions_1) - 1
    format_extension extension_one_start_date, extension_one_end_date
  end

  def extension_two_description
    extension_one_start_date = @procurement.initial_call_off_start_date.next_year(@procurement.initial_call_off_period)
    start_date = extension_one_start_date.next_year(@procurement.optional_call_off_extensions_1)
    end_date = (start_date - 1).next_year(@procurement.optional_call_off_extensions_2)
    format_extension start_date, end_date
  end

  def extension_three_description
    extension_one_start_date = @procurement.initial_call_off_start_date.next_year(@procurement.initial_call_off_period)
    start_date = extension_one_start_date.next_year(@procurement.optional_call_off_extensions_1 + +@procurement.optional_call_off_extensions_2)
    end_date = (start_date - 1).next_year(@procurement.optional_call_off_extensions_3)
    format_extension start_date, end_date
  end

  def extension_four_description
    extension_one_start_date = @procurement.initial_call_off_start_date.next_year(@procurement.initial_call_off_period)
    start_date = extension_one_start_date.next_year(@procurement.optional_call_off_extensions_1 + @procurement.optional_call_off_extensions_2 + @procurement.optional_call_off_extensions_3)
    end_date = (start_date - 1).next_year(@procurement.optional_call_off_extensions_4)
    format_extension start_date, end_date
  end
end
