require 'rails_helper'

RSpec.describe ProcurementCsvExport do
  let!(:procurement_in_search) { create(:facilities_management_procurement) }
  let!(:procurement_in_results) { create(:facilities_management_procurement_direct_award, aasm_state: 'results') }

  # rubocop:disable Rails/SkipsModelValidations
  let!(:procurement_in_da) do
    proc = create(:facilities_management_procurement_with_contact_details)
    proc.procurement_suppliers.first.update_attribute(:aasm_state, 'sent')
    proc.reload
  end
  # rubocop:enable Rails/SkipsModelValidations

  describe '.find_procurements' do
    subject(:found_procurements) { described_class.find_procurements }

    describe 'Procurement' do
      context 'with no contracts' do
        it 'includes procurement' do
          expect(found_procurements).to include(procurement_in_search)
        end
      end

      context 'with only unsent contracts' do
        it 'includes procurement' do
          expect(found_procurements).to include(procurement_in_results)
        end
      end

      context 'with sent contract' do
        it 'excludes procurement' do
          expect(found_procurements).not_to include(procurement_in_da)
        end
      end
    end
  end

  describe '.find_contracts' do
    subject(:found_contracts) { described_class.find_contracts }

    describe 'Procurement' do
      context 'with no contracts' do
        it 'excludes procurement' do
          expect(found_contracts.map(&:procurement)).not_to include(procurement_in_search)
        end
      end

      context 'with only unsent contracts' do
        it 'excludes procurement' do
          expect(found_contracts.map(&:procurement)).not_to include(procurement_in_results)
        end
      end

      context 'with sent contract' do
        it 'includes procurement' do
          expect(found_contracts.map(&:procurement)).to include(procurement_in_da)
        end
      end
    end
  end
end
