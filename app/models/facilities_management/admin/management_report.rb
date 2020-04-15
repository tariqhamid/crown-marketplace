module FacilitiesManagement
  module Admin
    class ManagementReport
      include ActiveModel::Model
      include ActiveModel::Validations
      include ActiveModel::Validations::Callbacks
      include Virtus.model

      attribute :start_date
      attribute :end_date
      attribute :start_date_dd
      attribute :start_date_mm
      attribute :start_date_yyyy
      attribute :end_date_dd
      attribute :end_date_mm
      attribute :end_date_yyyy

      validate :dates_valid?

      def initialize(start_date, end_date)
        @start_date = start_date
        @end_date = end_date
      end

      def set_start_date
        self.start_date = Date.new(start_date_yyyy.to_i, start_date_mm.to_i, start_date_dd.to_i)
      rescue StandardError
        errors.add(:start_date, 'Enter a valid date')
        self.start_date = nil
      end

      def set_end_date
        self.end_date = Date.new(end_date_yyyy.to_i, end_date_mm.to_i, end_date_dd.to_i)
      rescue StandardError
        errors.add(:end_date, 'Enter a valid date')
        self.end_date = nil
      end

      def dates_present?
        dates_present = true
        if [start_date_dd, start_date_mm, start_date_yyyy].any?(&:blank?)
          errors.add(:start_date, 'You must enter a date')
          dates_present = false
        end
        if [end_date_dd, end_date_mm, end_date_yyyy].any?(&:blank?)
          errors.add(:end_date, 'You must enter a date')
          dates_present = false
        end
        dates_present
      end

      def dates_valid?
        return false unless dates_present?

        set_start_date
        set_end_date

        return false if start_date.nil? || end_date.nil?

        if end_date < start_date
          errors.add(:end_date, "The 'To' date must be the same or after the 'From' date")
          return false
        end

        true
      end
    end
  end
end
