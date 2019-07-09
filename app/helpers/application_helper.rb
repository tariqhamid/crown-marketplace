# rubocop:disable Metrics/ModuleLength
module ApplicationHelper
  ADMIN_CONTROLLERS = ['supply_teachers/admin', 'management_consultancy/admin'].freeze

  def miles_to_metres(miles)
    DistanceConverter.miles_to_metres(miles)
  end

  def metres_to_miles(metres)
    DistanceConverter.metres_to_miles(metres)
  end

  def feedback_email_link
    govuk_email_link(Marketplace.feedback_email_address, t('layouts.application.feedback_aria_label'), css_class: 'govuk-link ga-feedback-mailto')
  end

  def support_email_link(label)
    govuk_email_link(Marketplace.support_email_address, label, css_class: 'govuk-link ga-support-mailto')
  end

  def footer_email_link(label)
    mail_to(Marketplace.support_email_address, Marketplace.support_email_address, class: 'govuk-link ga-support-mailto', 'aria-label': label)
  end

  def dfe_account_request_url
    'https://ccsheretohelp.uk/contact/?type=ST18/19'
  end

  def support_telephone_number
    Marketplace.support_telephone_number
  end

  def govuk_email_link(email_address, aria_label, css_class: 'govuk-link')
    mail_to(email_address, t('layouts.application.feedback'), class: css_class, 'aria-label': aria_label)
  end

  def govuk_form_group_with_optional_error(journey, *attributes)
    attributes_with_errors = attributes.select { |a| journey.errors[a].any? }

    css_classes = ['govuk-form-group']
    css_classes += ['govuk-form-group--error'] if attributes_with_errors.any?

    content_tag :div, class: css_classes do
      yield
    end
  end

  def govuk_fieldset_with_optional_error(journey, *attributes)
    attributes_with_errors = attributes.select { |a| journey.errors[a].any? }

    options = { class: 'govuk-fieldset' }
    options['aria-describedby'] = attributes_with_errors.map { |a| error_id(a) } if attributes_with_errors.any?

    content_tag :fieldset, options do
      yield
    end
  end

  def display_errors(journey, *attributes)
    safe_join(attributes.map { |a| display_error(journey, a) })
  end

  def display_error(journey, attribute)
    error = journey.errors[attribute].first
    return if error.blank?

    content_tag :span, id: error_id(attribute), class: 'govuk-error-message' do
      error
    end
  end

  def css_classes_for_input(journey, attribute, extra_classes = [])
    error = journey.errors[attribute].first

    css_classes = ['govuk-input'] + extra_classes
    css_classes += ['govuk-input--error'] if error.present?
    css_classes
  end

  def error_id(attribute)
    "#{attribute}-error"
  end

  def page_title
    title = %i[page_title_prefix page_title page_section].map do |title_bit|
      content_for(title_bit)
    end
    title += [t('layouts.application.title')]
    title.reject(&:blank?).map(&:strip).join(': ')
  end

  def add_optional_error_prefix_to_page_title(errors)
    content_for(:page_title_prefix) { t('layouts.application.error_prefix') } unless errors.empty?
  end

  def hidden_fields_for_previous_steps_and_responses(journey)
    html = ActiveSupport::SafeBuffer.new
    journey.previous_questions_and_answers.each do |(key, value)|
      if value.is_a? Array
        value.each do |v|
          html += hidden_field_tag("#{key}[]", v, id: nil)
        end
      else
        html += hidden_field_tag(key, value)
      end
    end
    html
  end

  def link_to_service_start_page
    render partial: "#{controller.class.parent_name.underscore}/link_to_start_page" if controller.class.parent_name
  end

  def service_start_page_path
    send controller.class.parent_name.underscore + '_path' if controller.class.parent_name
  end

  def service_destroy_user_session_path
    send controller.class.parent_name.underscore + '_destroy_user_session_path' if controller.class.parent_name
  end

  def service_gateway_path
    send controller.class.parent_name.underscore + '_gateway_path' if controller.class.parent_name
  end

  def service_destroy_session_path
    if controller.class.parent_name
      send controller.class.parent_name.underscore.tr('/', '_') + '_destroy_user_session_path'
    else
      send 'destroy_user_session_path'
    end
  end

  def landing_or_admin_page
    controller.action_name == 'index' || controller.action_name == 'landing_page' || ADMIN_CONTROLLERS.include?(controller.class.parent_name.try(:underscore))
  end

  def a_supply_teachers_path?
    controller.class.parent.name == 'SupplyTeachers'
  end
end
# rubocop:enable Metrics/ModuleLength
