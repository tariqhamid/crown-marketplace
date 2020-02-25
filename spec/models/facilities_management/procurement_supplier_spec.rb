require 'rails_helper'

RSpec.describe FacilitiesManagement::ProcurementSupplier, type: :model do
  let(:current_year) { Date.current.year.to_s }
  let(:da_current_year_1) { create(:facilities_management_procurement_supplier_da, contract_number: "RM3860-DA0001-#{current_year}") }
  let(:da_current_year_2) { create(:facilities_management_procurement_supplier_da, contract_number: "RM3860-DA0002-#{current_year}") }
  let(:da_previous_year_1) { create(:facilities_management_procurement_supplier_da, contract_number: 'RM3860-DA0003-2019') }
  let(:da_previous_year_2) { create(:facilities_management_procurement_supplier_da, contract_number: 'RM3860-DA0004-2019') }
  let(:fc_current_year_1) { create(:facilities_management_procurement_supplier_fc, contract_number: "RM3860-FC0005-#{current_year}") }
  let(:fc_current_year_2) { create(:facilities_management_procurement_supplier_fc, contract_number: "RM3860-FC0006-#{current_year}") }
  let(:fc_previous_year_1) { create(:facilities_management_procurement_supplier_fc, contract_number: 'RM3860-FC0007-2019') }
  let(:fc_previous_year_2) { create(:facilities_management_procurement_supplier_fc, contract_number: 'RM3860-FC0008-2019') }

  before do
    da_current_year_1
    da_current_year_2
    da_previous_year_1
    da_previous_year_2
    fc_current_year_1
    fc_current_year_2
    fc_previous_year_1
    fc_previous_year_2
  end

  describe '.used_direct_award_contract_numbers_for_current_year' do
    it 'presents all of the direct award contract numbers used for the current year' do
      expect(described_class.used_direct_award_contract_numbers_for_current_year).to match(['0001', '0002'])
    end

    it 'does not present any of the direct award contract numbers used for the previous years' do
      expect(described_class.used_direct_award_contract_numbers_for_current_year).not_to match(['0003', '0004'])
    end
  end

  describe '.used_further_competition_contract_numbers_for_current_year' do
    it 'presents all of the further competition contract numbers used for the current year' do
      expect(described_class.used_further_competition_contract_numbers_for_current_year).to match(['0005', '0006'])
    end

    it 'does not present any of the further competition contract numbers used for the previous years' do
      expect(described_class.used_further_competition_contract_numbers_for_current_year).not_to match(['0007', '0008'])
    end
  end

  describe '.generate_contract_number' do
    let(:direct_award) { create(:facilities_management_procurement_supplier_da) }
    let(:further_competition) { create(:facilities_management_procurement_supplier_fc) }
    let(:number_array) { (1..9999).map { |integer| format('%04d', integer % 10000) } }
    let(:expected_number) { number_array.sample }

    before do
      allow(described_class).to receive(:used_direct_award_contract_numbers_for_current_year) { number_array - [expected_number] }
      allow(described_class).to receive(:used_further_competition_contract_numbers_for_current_year) { number_array - [expected_number] }
    end

    context 'with a procurement in direct award' do
      it 'returns an available number for a direct award contract' do
        expect(direct_award.send(:generate_contract_number)).to eq("RM3830-DA#{expected_number}-#{current_year}")
      end
    end

    context 'with a procurement in further competition' do
      it 'returns an available number for a further competition contract' do
        expect(further_competition.send(:generate_contract_number)).to eq("RM3830-FC#{expected_number}-#{current_year}")
      end
    end
  end

  describe '.closed?' do
    let(:procurement) { create(:facilities_management_procurement, user: user) }
    let(:user) { create(:user) }
    let(:supplier_uuid) { 'eb7b05da-e52e-46a3-99ae-2cb0e6226232' }
    let(:da_value_test1) {  347.60116658878 }
    let(:da_value_test2) {  865.24783745402 }
    let(:da_value_test3) { 1292.48276446867 }
    let(:da_value_test4) { 1517.20280381278 }
    let(:obj) { double }

    before do
      allow(CCS::FM::Supplier.supplier_name('any')).to receive(:id).and_return(supplier_uuid)
      allow(FacilitiesManagement::DirectAwardEligibleSuppliers).to receive(:new).with(procurement.id).and_return(obj)
      allow(obj).to receive(:assessed_value).and_return(0.1234)
      allow(obj).to receive(:lot_number).and_return('1a')
      allow(obj).to receive(:sorted_list).and_return([[:test1, da_value_test1], [:test2, da_value_test2], [:test3, da_value_test3], [:test4, da_value_test4]])
      allow(procurement).to receive(:buildings_standard).and_return('STANDARD')
      procurement.save_eligible_suppliers_and_set_state
      # rubocop:disable RSpec/AnyInstance
      allow_any_instance_of(described_class).to receive(:send_offer_email)
      # rubocop:enable RSpec/AnyInstance
    end

    context 'when all contracts are unsent' do
      it 'no contracts will be closed' do
        closed_contracts = procurement.procurement_suppliers.map(&:closed?)
        expect(closed_contracts.any?(true)).to be false
      end
    end

    context 'when three contracts are sent' do
      it 'will return true for the first 2 and false for the third' do
        procurement.procurement_suppliers[0].offer_to_supplier
        procurement.procurement_suppliers[1].offer_to_supplier
        closed_contracts = procurement.procurement_suppliers.map(&:closed?)
        expect(closed_contracts[0]).to be true
        expect(closed_contracts[1]).to be true
        expect(closed_contracts[2]).to be false
      end
    end

    context 'when the procurement state is closed' do
      it 'will return true for all the contracts' do
        procurement.aasm_state = 'closed'
        closed_contracts = procurement.procurement_suppliers.map(&:closed?)
        expect(closed_contracts.any?(false)).to be false
      end
    end
  end
end
