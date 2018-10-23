class SearchController < ApplicationController
  def question
    @form_path = search_answer_path(slug: journey.current_slug)
    @back_path = search_question_path(slug: journey.previous_slug, params: journey.params) if journey.previous_slug
    render journey.template
  end

  def answer
    if journey.invalid?
      redirect_to(
        search_question_path(slug: journey.current_slug, params: journey.params),
        flash: { error: journey.error }
      )
    else
      redirect_to next_step_path
    end
  end

  private

  def next_step_path
    case journey.next_slug
    when 'results'
      branches_path(params: journey.params)
    when 'master-vendor-managed-service'
      master_vendors_path(journey.params)
    else
      search_question_path(slug: journey.next_slug, params: journey.params)
    end
  end

  def journey
    first_step_class = Steps::HireViaAgency
    @journey ||= Journey.new(first_step_class, params[:slug], params)
  end
end
