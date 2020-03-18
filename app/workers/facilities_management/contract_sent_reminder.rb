module FacilitiesManagement
  class ContractSentReminder
    include Sidekiq::Worker
    sidekiq_options queue: 'fm', retry: true

    def perform(id)
      contract = FacilitiesManagement::ProcurementSupplier.find(id)
      contract.send_reminder_email if contract.aasm_state == 'sent'
    end
  end
end
