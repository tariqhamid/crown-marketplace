# rubocop:disable Metrics/ModuleLength
module ProcurementValidator
  extend ActiveSupport::Concern

  # rubocop:disable Metrics/BlockLength
  included do
    # validations on :contract_name step
    before_validation :remove_excess_whitespace_from_name, on: :contract_name
    validates :contract_name, presence: true, on: %i[contract_name]
    validates :contract_name, uniqueness: { scope: :user }, on: :contract_name
    validates :contract_name, length: 1..100, on: :contract_name

    # validations on :estimated_annual_cost step
    validates :estimated_cost_known, inclusion: { in: [true, false] }, on: %i[estimated_annual_cost]
    validates :estimated_annual_cost, presence: true, if: -> { estimated_cost_known? }, on: :estimated_annual_cost
    validates :estimated_annual_cost, numericality: { allow_nil: false, only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 999999999 }, if: -> { estimated_cost_known? }, on: :estimated_annual_cost
    # validations on :procurement_buildings step
    validate :at_least_one_active_procurement_building, on: %i[procurement_buildings]

    validate :service_codes_not_empty, on: %i[services]

    validates :tupe, inclusion: { in: [true, false] }, on: %i[tupe]

    validates :payment_method, inclusion: { in: ['bacs', 'card'] }, on: %i[payment_method]

    validates :using_buyer_detail_for_invoice_details, inclusion: { in: [true, false] }, on: %i[invoicing_contact_details]

    validates :using_buyer_detail_for_authorised_detail, inclusion: { in: [true, false] }, on: %i[authorised_representative]

    validates :using_buyer_detail_for_notices_detail, inclusion: { in: [true, false] }, on: %i[notices_contact_details]

    validates :local_government_pension_scheme, inclusion: { in: [true, false] }, on: %i[local_government_pension_scheme]

    #############################################
    # Validation rules for contract-dates
    # these rules need to cover
    #   initial_call_off_period (int)
    #   initial_call_off_start_date (date)
    #   initial_call_off_end_date (date)
    #   mobilisation_period (int)
    #   extension_period (int)
    #   optional_call_off_extensions_1 (int)
    #   optional_call_off_extensions_2 (int)
    #   optional_call_off_extensions_3 (int)
    #   optional_call_off_extensions_4 (int)
    validates :initial_call_off_period, presence: true, on: :contract_dates
    validates :initial_call_off_period, numericality: { allow_nil: false, only_integer: true, greater_than_or_equal_to: 1 }, if: -> { initial_call_off_period.present? }, on: :contract_dates
    validates :initial_call_off_period, numericality: { allow_nil: false, only_integer: true, less_than_or_equal_to: 7 }, if: -> { initial_call_off_period.present? }, on: :contract_dates
    validate  :initial_call_off_start_date_yyyy_invalid, on: :contract_dates
    validates :initial_call_off_start_date, presence: true, date: { after_or_equal_to: proc { Time.zone.today } }, if: :initial_call_off_period_expects_a_date?, on: %i[contract_dates all]
    validate  :initial_call_off_start_date_yyyy_after_2100, on: :contract_dates
    validate  :initial_call_off_start_date_valid_date, if: -> { initial_call_off_period_expects_a_date? && initial_call_off_period_whole_number? }, on: :contract_dates

    validates :mobilisation_period_required, inclusion: { in: [true, false] }, on: :contract_dates
    validates :mobilisation_period_required, inclusion: { in: [true], message: :not_valid_with_tupe }, if: -> { tupe }, on: :contract_dates
    validates :mobilisation_period, presence: true, if: -> { mobilisation_period_required && initial_call_off_start_date.present? }, on: :contract_dates
    validates :mobilisation_period, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 52 }, if: -> { mobilisation_period_required && initial_call_off_start_date.present? }, on: :contract_dates
    validates :mobilisation_period, numericality: { only_integer: true, greater_than_or_equal_to: 4, less_than_or_equal_to: 52 }, if: -> { mobilisation_period_required && initial_call_off_start_date.present? && tupe }, on: :contract_dates
    validate  :mobilisation_start_date_validation, if: -> { mobilisation_period_required && initial_call_off_start_date.present? && mobilisation_period.present? && mobilisation_period <= 52 }, on: %i[contract_dates all]

    validates :extensions_required, inclusion: { in: [true, false] }, on: :contract_dates
    validates :optional_call_off_extensions_1, presence: true, if: -> { extensions_required && initial_call_off_start_date.present? }, on: :contract_dates
    validates :optional_call_off_extensions_1, numericality: { allow_nil: false, only_integer: true, greater_than_or_equal_to: 1 }, if: -> { extensions_required && initial_call_off_start_date.present? }, on: :contract_dates
    validates :optional_call_off_extensions_2, presence: true, numericality: { allow_nil: false, only_integer: true, greater_than_or_equal_to: 1 }, if: -> { extensions_required && (call_off_extension_2 != 'false' || !optional_call_off_extensions_2.nil?) }, on: :contract_dates
    validates :optional_call_off_extensions_3, presence: true, numericality: { allow_nil: false, only_integer: true, greater_than_or_equal_to: 1 }, if: -> { extensions_required && (call_off_extension_3 != 'false' || !optional_call_off_extensions_3.nil?) }, on: :contract_dates
    validates :optional_call_off_extensions_4, presence: true, numericality: { allow_nil: false, only_integer: true, greater_than_or_equal_to: 1 }, if: -> { extensions_required && (call_off_extension_4 != 'false' || !optional_call_off_extensions_4.nil?) }, on: :contract_dates
    validate :optional_call_off_extensions_too_long, on: :contract_dates
    validate :optional_call_off_extensions_catch_validation, on: :contract_dates

    #
    # End of validation rules for contract-dates
    #############################################
    validates :security_policy_document_required, inclusion: { in: [true, false] }, on: :security_policy_document
    validates :security_policy_document_name, presence: true, if: :security_policy_document_required?, on: :security_policy_document
    validates :security_policy_document_version_number, presence: true, if: :security_policy_document_required?, on: :security_policy_document
    validate :security_policy_document_date_valid?, on: :security_policy_document

    # Additional validations for the 'Continue' button on the 'Detailed search summary' page - validating on :all
    validate :presence_of_about_the_contract, on: :all
    validate :at_least_one_building, on: :all
    validate :all_services_valid, on: :all
    validate :validate_contract_period_questions, on: :all
    validate :validate_mobilisation_and_tupe, on: :all
    validate :at_least_one_service_per_building, on: :all

    # Validation for the contract_details page
    validate :validate_contract_details, on: :contract_details

    # Validation for the choose_contract_value page
    validates :lot_number, presence: true, inclusion: { in: %w[1a 1b 1c] }, on: :choose_contract_value
    validate :lot_number_in_range, on: :choose_contract_value
    validates :lot_number_selected_by_customer, acceptance: true, on: :choose_contract_value

    private

    #############################################
    # Start of validation methods for contract-dates
    def initial_call_off_start_date_valid_date
      Date.parse("#{initial_call_off_start_date_dd.to_i}/#{initial_call_off_start_date_mm.to_i}/#{initial_call_off_start_date_yyyy.to_i}")
    rescue ArgumentError
      errors.add(:initial_call_off_start_date, :not_a_date)
    end

    def initial_call_off_start_date_yyyy_invalid
      errors.add(:initial_call_off_start_date, :not_a_date) if initial_call_off_start_date_yyyy.to_i < 100
    end

    def initial_call_off_start_date_yyyy_after_2100
      errors.add(:initial_call_off_start_date, :after_2100) if initial_call_off_start_date_yyyy.to_i > 2100
    end

    def remove_excess_whitespace_from_name
      self.contract_name = contract_name&.split&.join(' ')
    end

    #############################################
    # Start of validation methods for contract-dates
    def validate_contract_data?
      initial_call_off_period.present? ? initial_call_off_period.positive? : false
    end

    def initial_call_off_period_whole_number?
      errors.details[:initial_call_off_period].none? { |error| error[:error] == :not_an_integer }
    end

    def initial_call_off_period_expects_a_date?
      return (1..7).include? initial_call_off_period if initial_call_off_period.present?

      false
    end

    def total_extensions
      optional_call_off_extensions_1.to_i + optional_call_off_extensions_2.to_i + optional_call_off_extensions_3.to_i + optional_call_off_extensions_4.to_i
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    def optional_call_off_extensions_catch_validation
      unless optional_call_off_extensions_4.nil?
        errors.add(:optional_call_off_extensions_3, :blank) if optional_call_off_extensions_3.nil?
        errors.add(:optional_call_off_extensions_2, :blank) if optional_call_off_extensions_2.nil?
      end

      errors.add(:optional_call_off_extensions_2, :blank) if (!optional_call_off_extensions_3.nil? || !optional_call_off_extensions_4.nil?) && optional_call_off_extensions_2.nil?
    end
    # rubocop:enable Metrics/CyclomaticComplexity

    def optional_call_off_extensions_too_long
      return if initial_call_off_period.to_i > 7

      errors.add(:optional_call_off_extensions_1, :too_long) unless initial_call_off_period.to_i + total_extensions <= 10
    end
    # End of validation methods for contract-dates
    #############################################

    def at_least_one_active_procurement_building
      errors.add(:procurement_buildings, :invalid) unless procurement_buildings.map(&:active).any?(true)
    end

    def service_codes_not_empty
      errors.add(:service_codes, :invalid) if defined?(service_codes) && service_codes.empty?
    end

    def security_policy_document_date_valid?
      errors.add(:security_policy_document_date, :not_a_date) unless all_security_policy_document_date_fields_valid?
    end

    def all_security_policy_document_date_fields_valid?
      return true if security_policy_document_date_yyyy.blank? && security_policy_document_date_mm.blank? && security_policy_document_date_dd.blank?

      return false if security_policy_document_date_yyyy.to_i < 1970

      Date.valid_date? security_policy_document_date_yyyy.to_i, security_policy_document_date_mm.to_i, security_policy_document_date_dd.to_i
    end

    def presence_of_about_the_contract
      errors.add(:contract_name, :not_present) if contract_name.blank?
      errors.add(:estimated_cost_known, :not_present) if estimated_cost_known.nil?
      errors.add(:tupe, :not_present) if tupe.nil?
    end

    def validate_contract_period_questions
      errors.add(:initial_call_off_period, :not_present) if initial_call_off_period.blank?
    end

    def at_least_one_building
      errors.add(:procurement_buildings, :not_present) if active_procurement_buildings.none?
    end

    def at_least_one_service_per_building
      errors.add(:base, :services_not_present) if active_procurement_buildings.none? || procurement_building_services.none?
    end

    def all_services_valid
      active_procurement_buildings.each do |pb|
        pb.errors.add(:base, :services_invalid) unless pb.valid?(:procurement_building_services)
      end
    end

    def validate_mobilisation_and_tupe
      errors.add(:mobilisation_period, :not_valid_with_tupe) if ((mobilisation_period_required && mobilisation_period < 4) || mobilisation_period_required == false) && tupe == true
    end

    def lot_number_in_range
      lot_number_in_correct_range = if assessed_value < 7000000
                                      true
                                    elsif assessed_value <= 50000000
                                      %w[1b 1c].include? lot_number
                                    else
                                      lot_number == '1c'
                                    end

      errors.add(:lot_number, :blank) unless lot_number_in_correct_range
    end

    # rubocop:disable Metrics/CyclomaticComplexity, Metrics/AbcSize
    def validate_contract_details
      errors.add(:payment_method, :not_present_contract_details) if payment_method.nil?
      errors.add(:using_buyer_detail_for_invoice_details, :not_present_contract_details) if using_buyer_detail_for_invoice_details.nil?
      errors.add(:using_buyer_detail_for_authorised_detail, :not_present_contract_details) if using_buyer_detail_for_authorised_detail.nil?
      errors.add(:using_buyer_detail_for_notices_detail, :not_present_contract_details) if using_buyer_detail_for_notices_detail.nil?
      errors.add(:security_policy_document_required, :not_present_contract_details) if security_policy_document_required.nil?
      errors.add(:local_government_pension_scheme, :not_present_contract_details) if local_government_pension_scheme.nil?
      errors.any?
    end
  end
  # rubocop:enable Metrics/BlockLength, Metrics/AbcSize, Metrics/CyclomaticComplexity

  def mobilisation_start_date_validation
    mobilisation_start_date = initial_call_off_start_date - mobilisation_period.weeks - 1.day
    errors.add(:mobilisation_start_date, :greater_than) if mobilisation_start_date <= Time.zone.today
  end
end
# rubocop:enable Metrics/ModuleLength
