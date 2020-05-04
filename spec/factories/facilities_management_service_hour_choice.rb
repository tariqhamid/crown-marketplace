FactoryBot.define do
  factory :facilities_management_service_hour_choice_defaults, class: FacilitiesManagement::ServiceHourChoice do
    service_choice { :not_required }
    uom { 0 }
    start_hour { '' }
    start_minute { '' }
    start_ampm { 'AM' }
    end_hour { '' }
    end_minute { '' }
    end_ampm { 'AM' }
  end

  factory :facilities_management_service_hour_choice_monday, parent: :facilities_management_service_hour_choice_defaults do
  end

  factory :facilities_management_service_hour_choice_tuesday, parent: :facilities_management_service_hour_choice_defaults do
    service_choice { :all_day }
  end

  factory :facilities_management_service_hour_choice_wednesday, parent: :facilities_management_service_hour_choice_defaults do
    service_choice { :hourly }
    start_hour { '08' }
    start_minute { '00' }
    end_hour { '05' }
    end_minute { '30' }
    end_ampm { 'PM' }
  end

  factory :facilities_management_service_hour_choice_thursday, parent: :facilities_management_service_hour_choice_defaults do
  end

  factory :facilities_management_service_hour_choice_friday, parent: :facilities_management_service_hour_choice_defaults do
    service_choice { :all_day }
  end

  factory :facilities_management_service_hour_choice_saturday, parent: :facilities_management_service_hour_choice_defaults do
    service_choice { :hourly }
    start_hour { '10' }
    start_minute { '00' }
    start_ampm { 'PM' }
    end_hour { '05' }
    end_minute { '30' }
    end_ampm { 'AM' }
  end

  factory :facilities_management_service_hour_choice_sunday, parent: :facilities_management_service_hour_choice_defaults do
  end
end
