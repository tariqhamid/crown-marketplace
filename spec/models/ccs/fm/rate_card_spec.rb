require 'rails_helper'

RSpec.describe CCS::FM::RateCard, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  it 'can contain entries' do
    expect(CCS::FM::RateCard.count).to be > 0
  end

  it 'can retrieve latest entry' do
    current = CCS::FM::RateCard.last
    expect(current.data['Prices'].count).to be > 0
  end
end