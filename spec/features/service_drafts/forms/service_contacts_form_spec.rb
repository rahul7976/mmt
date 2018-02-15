require 'rails_helper'

describe 'Service Contacts Form', js: true do
  before do
    login
    draft = create(:empty_service_draft, user: User.where(urs_uid: 'testuser').first)
    visit edit_service_draft_path(draft, 'service_contacts')
    click_on 'Expand All'
  end

  context 'when submitting the form' do
    before do
      add_contact_groups
      add_contact_persons

      within '.nav-top' do
        click_on 'Save'
      end

      # TODO validation isn't working correctly
      click_on 'Yes'
      click_on 'Expand All'
    end

    it 'displays a confirmation message' do
      expect(page).to have_content('Service Draft Updated Successfully!')
    end

    context 'when viewing the form' do
      include_examples 'Service Contacts Form'
    end
  end
end
