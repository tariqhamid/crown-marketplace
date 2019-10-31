require 'rails_helper'

RSpec.describe FacilitiesManagement::ProcurementBuildingService, type: :model do
  subject(:procurement_building_service) { build(:facilities_management_procurement_building_service, procurement_building: create(:facilities_management_procurement_building, procurement: create(:facilities_management_procurement))) }

  describe '#validations' do
    context 'when code = C.1' do
      it 'is valid if service_standard is present' do
        procurement_building_service.code = 'C.1'
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq true
      end

      it 'is not valid if service_standard is not present on ppm_standards context' do
        procurement_building_service.code = 'C.1'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq false
      end

      it 'does not validate if service_standards is not present and not on ppm_standards context' do
        procurement_building_service.code = 'C.1'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = C.2' do
      it 'is valid if service_standard is present' do
        procurement_building_service.code = 'C.2'
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq true
      end

      it 'is not valid if service_standard is not present on ppm_standards context' do
        procurement_building_service.code = 'C.2'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq false
      end

      it 'does not validate if service_standards is not present and not on ppm_standards context' do
        procurement_building_service.code = 'C.2'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = C.3' do
      it 'is valid if service_standard is present' do
        procurement_building_service.code = 'C.3'
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq true
      end

      it 'is not valid if service_standard is not present on ppm_standards context' do
        procurement_building_service.code = 'C.3'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq false
      end

      it 'does not validate if service_standards is not present and not on ppm_standards context' do
        procurement_building_service.code = 'C.3'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = C.4' do
      it 'is valid if service_standard is present' do
        procurement_building_service.code = 'C.4'
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq true
      end

      it 'is not valid if service_standard is not present on ppm_standards context' do
        procurement_building_service.code = 'C.4'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq false
      end

      it 'does not validate if service_standards is not present and not on ppm_standards context' do
        procurement_building_service.code = 'C.4'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = C.5' do
      it 'is valid if service_standard is present' do
        procurement_building_service.code = 'C.5'
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq true
      end

      it 'is not valid if service_standard is not present on ppm_standards context' do
        procurement_building_service.code = 'C.5'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq false
      end

      it 'does not validate if service_standards is not present and not on ppm_standards context' do
        procurement_building_service.code = 'C.5'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = C.6' do
      it 'is valid if service_standard is present' do
        procurement_building_service.code = 'C.6'
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq true
      end

      it 'is not valid if service_standard is not present on ppm_standards context' do
        procurement_building_service.code = 'C.6'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq false
      end

      it 'does not validate if service_standards is not present and not on ppm_standards context' do
        procurement_building_service.code = 'C.6'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = C.11' do
      it 'is valid if service_standard is present' do
        procurement_building_service.code = 'C.11'
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq true
      end

      it 'is not valid if service_standard is not present on ppm_standards context' do
        procurement_building_service.code = 'C.11'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq false
      end

      it 'does not validate if service_standards is not present and not on ppm_standards context' do
        procurement_building_service.code = 'C.11'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = C.12' do
      it 'is valid if service_standard is present' do
        procurement_building_service.code = 'C.12'
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq true
      end

      it 'is not valid if service_standard is not present on ppm_standards context' do
        procurement_building_service.code = 'C.12'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq false
      end

      it 'does not validate if service_standards is not present and not on ppm_standards context' do
        procurement_building_service.code = 'C.12'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = C.13' do
      it 'is valid if service_standard is present' do
        procurement_building_service.code = 'C.13'
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq true
      end

      it 'is not valid if service_standard is not present on ppm_standards context' do
        procurement_building_service.code = 'C.13'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq false
      end

      it 'does not validate if service_standards is not present and not on ppm_standards context' do
        procurement_building_service.code = 'C.13'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = C.14' do
      it 'is valid if service_standard is present' do
        procurement_building_service.code = 'C.14'
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq true
      end

      it 'is not valid if service_standard is not present on ppm_standards context' do
        procurement_building_service.code = 'C.14'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq false
      end

      it 'does not validate if service_standards is not present and not on ppm_standards context' do
        procurement_building_service.code = 'C.14'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = E.4' do
      it 'validates no_of_appliances_for_testing grater than 0 if value is present' do
        procurement_building_service.code = 'E.4'
        procurement_building_service.no_of_appliances_for_testing = -1
        expect(procurement_building_service.valid?(:volume)).to eq false
      end

      it 'does not validate no_of_appliances_for_testing if value is not present' do
        procurement_building_service.code = 'E.4'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end

      it 'is valid if no_of_appliances_for_testing is present and greater than 0' do
        procurement_building_service.code = 'E.4'
        procurement_building_service.no_of_appliances_for_testing = 2
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = G.1' do
      it 'validates no_of_building_occupants grater than 0 if value is present' do
        procurement_building_service.code = 'G.1'
        procurement_building_service.no_of_building_occupants = -1
        expect(procurement_building_service.valid?(:volume)).to eq false
      end

      it 'does not validate no_of_building_occupants if value is not present' do
        procurement_building_service.code = 'G.1'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end

      it 'is valid if no_of_building_occupants is present and greater than 0' do
        procurement_building_service.code = 'G.1'
        procurement_building_service.no_of_building_occupants = 2
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = G.3' do
      it 'validates no_of_building_occupants grater than 0 if value is present' do
        procurement_building_service.code = 'G.3'
        procurement_building_service.no_of_building_occupants = -1
        expect(procurement_building_service.valid?(:volume)).to eq false
      end

      it 'does not validate no_of_building_occupants if value is not present' do
        procurement_building_service.code = 'G.3'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end

      it 'is valid if no_of_building_occupants is present and greater than 0' do
        procurement_building_service.code = 'G.3'
        procurement_building_service.no_of_building_occupants = 2
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = G.5' do
      it 'validates size_of_external_area grater than 0 if value is present' do
        procurement_building_service.code = 'G.5'
        procurement_building_service.size_of_external_area = -1
        expect(procurement_building_service.valid?(:volume)).to eq false
      end

      it 'does not validate size_of_external_area if value is not present' do
        procurement_building_service.code = 'G.5'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end

      it 'is valid if size_of_external_area is present and greater than 0' do
        procurement_building_service.code = 'G.5'
        procurement_building_service.size_of_external_area = 2
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = K.1' do
      it 'validates no_of_consoles_to_be_serviced grater than 0 if value is present' do
        procurement_building_service.code = 'K.1'
        procurement_building_service.no_of_consoles_to_be_serviced = -1
        expect(procurement_building_service.valid?(:volume)).to eq false
      end

      it 'does not validate no_of_consoles_to_be_serviced if value is not present' do
        procurement_building_service.code = 'K.1'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end

      it 'is valid if no_of_consoles_to_be_serviced is present and greater than 0' do
        procurement_building_service.code = 'K.1'
        procurement_building_service.no_of_consoles_to_be_serviced = 2
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = K.2' do
      it 'validates tones_to_be_collected_and_removed grater than 0 if value is present' do
        procurement_building_service.code = 'K.2'
        procurement_building_service.tones_to_be_collected_and_removed = -1
        expect(procurement_building_service.valid?(:volume)).to eq false
      end

      it 'does not validate tones_to_be_collected_and_removed if value is not present' do
        procurement_building_service.code = 'K.2'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end

      it 'is valid if tones_to_be_collected_and_removed is present and greater than 0' do
        procurement_building_service.code = 'K.2'
        procurement_building_service.tones_to_be_collected_and_removed = 2
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = K.3' do
      it 'validates tones_to_be_collected_and_removed grater than 0 if value is present' do
        procurement_building_service.code = 'K.3'
        procurement_building_service.tones_to_be_collected_and_removed = -1
        expect(procurement_building_service.valid?(:volume)).to eq false
      end

      it 'does not validate tones_to_be_collected_and_removed if value is not present' do
        procurement_building_service.code = 'K.3'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end

      it 'is valid if tones_to_be_collected_and_removed is present and greater than 0' do
        procurement_building_service.code = 'K.3'
        procurement_building_service.tones_to_be_collected_and_removed = 2
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = K.7' do
      it 'validates no_of_units_to_be_serviced grater than 0 if value is present' do
        procurement_building_service.code = 'K.7'
        procurement_building_service.no_of_units_to_be_serviced = -1
        expect(procurement_building_service.valid?(:volume)).to eq false
      end

      it 'does not validate no_of_units_to_be_serviced if value is not present' do
        procurement_building_service.code = 'K.7'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end

      it 'is valid if no_of_units_to_be_serviced is present and greater than 0' do
        procurement_building_service.code = 'K.7'
        procurement_building_service.no_of_units_to_be_serviced = 2
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = K.4' do
      it 'validates tones_to_be_collected_and_removed grater than 0 if value is present' do
        procurement_building_service.code = 'K.4'
        procurement_building_service.tones_to_be_collected_and_removed = -1
        expect(procurement_building_service.valid?(:volume)).to eq false
      end

      it 'does not validate tones_to_be_collected_and_removed if value is not present' do
        procurement_building_service.code = 'K.4'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end

      it 'is valid if tones_to_be_collected_and_removed is present and greater than 0' do
        procurement_building_service.code = 'K.4'
        procurement_building_service.tones_to_be_collected_and_removed = 2
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = K.5' do
      it 'validates tones_to_be_collected_and_removed grater than 0 if value is present' do
        procurement_building_service.code = 'K.5'
        procurement_building_service.tones_to_be_collected_and_removed = -1
        expect(procurement_building_service.valid?(:volume)).to eq false
      end

      it 'does not validate tones_to_be_collected_and_removed if value is not present' do
        procurement_building_service.code = 'K.5'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end

      it 'is valid if tones_to_be_collected_and_removed is present and greater than 0' do
        procurement_building_service.code = 'K.5'
        procurement_building_service.tones_to_be_collected_and_removed = 2
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = K.6' do
      it 'validates tones_to_be_collected_and_removed grater than 0 if value is present' do
        procurement_building_service.code = 'K.6'
        procurement_building_service.tones_to_be_collected_and_removed = -1
        expect(procurement_building_service.valid?(:volume)).to eq false
      end

      it 'does not validate tones_to_be_collected_and_removed if value is not present' do
        procurement_building_service.code = 'K.6'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end

      it 'is valid if tones_to_be_collected_and_removed is present and greater than 0' do
        procurement_building_service.code = 'K.6'
        procurement_building_service.tones_to_be_collected_and_removed = 2
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end
  end
end