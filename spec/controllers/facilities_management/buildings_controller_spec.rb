require 'rails_helper'
RSpec.describe FacilitiesManagement::BuildingsController, type: :controller do
  render_views
  describe 'GET #index' do
    context 'when logging in as a fm buyer with details' do
      it 'returns http success' do
        get :index
        expect(response).to have_http_status(:found)
      end
    end

    context 'when logging in as an st buyer' do
      login_st_buyer_with_detail
      it 'redirects to the not permitted page' do
        get :index

        expect(response).to redirect_to not_permitted_path(service: 'facilities_management')
      end
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:found)
    end

    context 'when logging in as an mc buyer' do
      login_mc_buyer_with_detail
      it 'redirects to the not permitted page' do
        get :new

        expect(response).to redirect_to not_permitted_path(service: 'facilities_management')
      end
    end
  end

  describe 'building steps' do
    context 'when create' do
      it 'step title is correct' do
        expect(controller.step_title(:create)).to eq(I18n.t('facilities_management.buildings.step_title.step_title', position: 1, total: 4))
      end

      it 'step footer is correct' do
        controller.action_name = 'gia'
        expect(controller.step_footer).to eq(I18n.t('facilities_management.buildings.step_footer.step_footer', description: BuildingsControllerNavigation::STEPS[:type][:desc]))
      end
    end

    context 'with maximum step number' do
      it 'wil be correct' do
        expect(controller.maximum_step_number).to eq(4)
      end
    end

    context 'with next_step' do
      it 'will be edit' do
        expect(controller.next_step('security')).to eq(BuildingsControllerNavigation::STEPS[:edit])
      end

      it 'will be type' do
        expect(controller.next_step('gia')[1]).to eq(BuildingsControllerNavigation::STEPS[:type])
      end
    end
  end

  describe '#ensure_postcode_is_valid' do
    context 'when the postcode is blank' do
      it 'returns the blank postcode' do
        expect(controller.ensure_postcode_is_valid('')).to eq ''
      end
    end

    context 'when the postcode is empty space' do
      it 'returns the blank postcode' do
        expect(controller.ensure_postcode_is_valid('  ')).to eq '  '
        expect(controller.ensure_postcode_is_valid(' ')).to eq ' '
      end
    end

    context 'when the postcode is not a valid postcode' do
      it 'returns the blank postcode' do
        postcode1 = "#{('aa1'..'zz9').to_a.sample} #{('1a'..'9z').to_a.sample}"
        postcode2 = "#{('aa11a'..'zz99z').to_a.sample} #{('1a'..'9z').to_a.sample}"
        postcode3 = "#{('aa1'..'zz9').to_a.sample} #{('1a'..'9z').to_a.sample}"
        expect(controller.ensure_postcode_is_valid(postcode1)).to eq postcode1
        expect(controller.ensure_postcode_is_valid(postcode2)).to eq postcode2
        expect(controller.ensure_postcode_is_valid(postcode3)).to eq postcode3
      end
    end

    context 'when the postcode is a valid postcode' do
      it 'returns the matching postcode' do
        postcode1 = "#{('aa1'..'zz9').to_a.sample} #{('1aa'..'9zz').to_a.sample}"
        postcode2 = "#{('aa1'..'zz9').to_a.sample} #{('1aa'..'9zz').to_a.sample}"
        expect(controller.ensure_postcode_is_valid(postcode1)).to eq postcode1
        expect(controller.ensure_postcode_is_valid(postcode2)).to eq postcode2
      end
    end
  end

  describe 'GET #show' do
    context 'when logging in as the fm buyer that created the building' do
      let(:building) { create(:facilities_management_building, user_id: subject.current_user.id) }

      login_fm_buyer_with_details
      it 'returns http success' do
        get :show, params: { id: building.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when logging in a different fm buyer' do
      let(:building) { create(:facilities_management_building, user_id: create(:user).id) }

      login_fm_buyer_with_details
      it 'redirects to the not permitted page' do
        get :show, params: { id: building.id }

        expect(response).to redirect_to not_permitted_path(service: 'facilities_management')
      end
    end
  end

  describe 'GET #edit' do
    context 'when logging in as the fm buyer that created the building' do
      let(:building) { create(:facilities_management_building, user_id: subject.current_user.id) }

      login_fm_buyer_with_details
      it 'returns http success' do
        get :edit, params: { id: building.id }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET #gia' do
    context 'when logging in as the fm buyer that created the building' do
      let(:building) { create(:facilities_management_building, user_id: subject.current_user.id) }

      login_fm_buyer_with_details
      it 'returns http success' do
        get :gia, params: { id: building.id }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET #type' do
    context 'when logging in as the fm buyer that created the building' do
      let(:building) { create(:facilities_management_building, user_id: subject.current_user.id) }

      login_fm_buyer_with_details
      it 'returns http success' do
        get :type, params: { id: building.id }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET #security' do
    context 'when logging in as the fm buyer that created the building' do
      let(:building) { create(:facilities_management_building, user_id: subject.current_user.id) }

      login_fm_buyer_with_details
      it 'returns http success' do
        get :security, params: { id: building.id }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST' do
    login_fm_buyer_with_details
    context 'when creating without a name' do
      it 'returns validation message' do
        post :create, params: { facilities_management_building: { building_name: '', address_line_1: 'line 1', address_town: 'town', address_postcode: 'SW1A 1AA' } }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('#building_name-error')
      end
    end

    context 'when creating without an address_line_1' do
      it 'returns validation message' do
        post :create, params: { facilities_management_building: { building_name: 'name', address_line_1: '', address_town: 'town', address_postcode: 'SW1A 1AA' } }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('#address-error')
      end
    end

    context 'when creating without an address_town' do
      it 'returns validation message' do
        post :create, params: { facilities_management_building: { building_name: 'name', address_line_1: 'line 1', address_town: '', address_postcode: 'SW1A 1AA' } }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('#address_region-error')
      end
    end

    context 'when creating without a postcode' do
      it 'returns validation message' do
        post :create, params: { facilities_management_building: { building_name: 'name', address_line_1: 'line 1', address_town: 'town', address_postcode: '' } }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('#address_postcode-error')
      end
    end

    context 'when adding a manual address' do
      it 'show the add_address page' do
        post :create, params: { add_address: 'add_address', facilities_management_building: { building_name: 'name', address_line_1: 'line 1', address_town: 'town', address_postcode: 'SW1A 1AA' } }
        expect(response).to have_http_status(:ok)
        expect(response.body).to render_template(:add_address)
      end

      it 'shows create page when address manually added' do
        post :create, params: { step: 'add_address', facilities_management_building: { building_name: 'name', address_line_1: 'line 1', address_town: 'town', address_postcode: 'SW1A 1AA' } }
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:new)
      end
    end

    context 'when saving correct building' do
      it 'will redirect to gia' do
        post :create, params: { facilities_management_building: { building_name: 'name', address_line_1: 'line 1', address_town: 'town', address_postcode: 'SW1A 1AA', address_region: 'Inner London - West', address_region_code: 'UKI3' } }
        expect(response).to have_http_status(:found)

        expect(response.headers['Location']).to include('gia')
      end

      it 'will redirect to building' do
        post :create, params: { save_and_return: '', facilities_management_building: { building_name: 'name', address_line_1: 'line 1', address_town: 'town', address_postcode: 'SW1A 1AA', address_region: 'Inner London - West', address_region_code: 'UKI3' } }
        expect(response).to have_http_status(:found)
        id = response.headers['Location'][-36, 36]
        expect(response.headers['Location']).to redirect_to(facilities_management_building_path(id))
      end
    end
  end

  describe 'PUT' do
    context 'when saving GIA' do
      let(:building) { create(:facilities_management_building, user_id: subject.current_user.id) }

      login_fm_buyer_with_details
      context 'when saving with empty value' do
        it 'returns validation message' do
          patch :update, params: { id: building.id, step: 'gia', facilities_management_building: { gia: '' } }
          expect(response).to have_http_status(:ok)
          expect(response.body).to include('#gia-error')
        end
      end

      context 'when saving with valid value' do
        it 'redirects to next step' do
          patch :update, params: { id: building.id, step: 'gia', facilities_management_building: { gia: '5432' } }
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to type_facilities_management_building_path
          building.reload
          expect(building.gia).to eq(5432)
        end
      end

      context 'when saving a manual address' do
        it 'will render add_address' do
          patch :update, params: { id: building.id, add_address: 'add_address', step: 'edit', facilities_management_building: { postcode_entry: 'SW1A 1AA', building_name: 'name', address_line_1: 'line 1', address_postcode: 'SW1A 1AA' } }
          expect(response).to have_http_status(:ok)
          expect(response).to render_template(:add_address)
        end
      end
    end

    context 'when saving building type' do
      let(:building) { create(:facilities_management_building, user_id: subject.current_user.id) }

      login_fm_buyer_with_details
      context 'when saving with empty value' do
        it 'returns validation message' do
          patch :update, params: { id: building.id, step: 'type', facilities_management_building: { building_type: '' } }
          expect(response).to have_http_status(:ok)
          expect(response.body).to include('#building_type-error')
        end
      end

      context 'when saving with valid value' do
        it 'returns validation message' do
          patch :update, params: { id: building.id, step: 'type', facilities_management_building: { building_type: 'other', other_building_type: 'test' } }
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to security_facilities_management_building_path
          building.reload
          expect(building.building_type).to eq('other')
        end
      end
    end

    context 'when saving security type' do
      let(:building) { create(:facilities_management_building, user_id: subject.current_user.id) }

      login_fm_buyer_with_details
      context 'when saving with empty value' do
        it 'returns validation message' do
          patch :update, params: { id: building.id, step: 'security', facilities_management_building: { security_type: '' } }
          expect(response).to have_http_status(:ok)
          expect(response.body).to include('#security_type-error')
        end
      end

      context 'when saving with valid value' do
        it 'returns validation message' do
          patch :update, params: { id: building.id, step: 'security', facilities_management_building: { security_type: 'other', other_security_type: 'test' } }
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to facilities_management_building_path
          building.reload
          expect(building.security_type).to eq('other')
        end
      end
    end

    context 'when editing add_address' do
      let(:building) { create(:facilities_management_building, user_id: subject.current_user.id) }

      login_fm_buyer_with_details
      it 'will redirect to add_address' do
        get :add_address, params: { id: building.id }
        expect(response).to render_template 'add_address'
      end

      it 'will display validation error' do
        patch :update, params: { id: building.id, step: 'add_address', facilities_management_building: { address_line_1: '' } }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('#address_line_1-error')
      end

      it 'will render the edit page' do
        patch :update, params: { id: building.id, step: 'add_address', facilities_management_building: { address_line_1: 'line1', address_town: 'town', address_postcode: 'SW1A 1AA' } }
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(edit_facilities_management_building_path)
        building.reload
        expect(building.address_town).to eq('town')
      end
    end
  end
end
