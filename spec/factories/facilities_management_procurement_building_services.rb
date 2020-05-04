require 'facilities_management/services_and_questions'
FactoryBot.define do
  factory :facilities_management_procurement_building_service, class: FacilitiesManagement::ProcurementBuildingService do
    name { Faker::Name.unique.name }
    code { 'C.1' }
    service_standard { 'A' }
  end

  factory :facilities_management_procurement_building_service_i1, class: FacilitiesManagement::ProcurementBuildingService do
    name { Faker::Name.unique.name }
    code { 'I.1' }
    service_standard { 'A' }
      # service_hours[:monday] => factory(:facilities_management_service_hour_choice_monday)

    # service_hours[:monday] = build(:facilities_management_service_hour_choice_monday)
    # service_hours[:tuesday] = build(:facilities_management_service_hour_choice_tuesday)
    # service_hours[:wednesday] = build(:facilities_management_service_hour_choice_wednesday)
    # service_hours[:thursday] = build(:facilities_management_service_hour_choice_thursday)
    # service_hours[:friday] = build(:facilities_management_service_hour_choice_friday)
    # service_hours[:saturday] = build(:facilities_management_service_hour_choice_saturday)
    # service_hours[:sunday] = build(:facilities_management_service_hour_choice_sunday)
  end
end
