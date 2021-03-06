module FacilitiesManagement::BuildingsHelper
  def address?(building)
    return false if building.blank?

    building.address_town || building.address_line_1 || building.address_postcode || building.address_region
  end

  def address_in_a_line(building)
    [building.address_line_1, building.address_line_2, building.address_town].reject(&:blank?).join(', ') + " #{building.address_postcode}"
  end

  def margin_if_security_has_other_error(building)
    building.errors.key?(:other_security_type) ? { style: 'margin-left: 1em' } : {}
  end

  def margin_if_type_has_other_error(building)
    building.errors.key?(:other_building_type) ? { style: 'margin-left: 1em' } : {}
  end

  def open_state_of_building_details(building)
    return false if building[:building_type].blank?

    if building.building_type == 'other' || building.errors.key?(:other_building_type) ||
       FacilitiesManagement::Building::BUILDING_TYPES[0..1].map { |bt| bt[:title] }.exclude?(building[:building_type])
      true
    else
      false
    end
  end

  def building_type_description(building_type_id)
    building_type = FacilitiesManagement::Building::BUILDING_TYPES.find { |bt| bt[:id] == building_type_id }
    if building_type.present?
      building_type[:title].capitalize
    else
      building_type_id.capitalize
    end
  end
end
