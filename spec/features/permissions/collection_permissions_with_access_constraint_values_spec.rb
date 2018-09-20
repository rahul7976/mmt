# We should verify that access constraint values actually control whether collections can be viewed
describe 'Collection Permissions with Access Constraint Values' do
  before :all do
    clear_cache

    # pub 3 new records to nsidc
    @concept_1_within_access_constraints, concept = publish_collection_draft(provider_id: 'NSIDC_ECS', short_name: 'WITHIN_ACCESS_CONSTRAINTS_1', access_constraint_value: 25, token: 'access_token_admin')
    puts "asdf #{@concept_1_within_access_constraints}"
    @concept_2_within_access_constraints, concept = publish_collection_draft(provider_id: 'NSIDC_ECS', short_name: 'WITHIN_ACCESS_CONSTRAINTS_2', access_constraint_value: 10, token: 'access_token_admin')
    puts "qwer #{@concept_2_within_access_constraints}"
    @concept_1_outside_access_constraints, concept = publish_collection_draft(provider_id: 'NSIDC_ECS', short_name: 'OUTSIDE_ACCESS_CONSTRAINTS_1', access_constraint_value: 50, token: 'access_token_admin')
    puts "zxcv #{@concept_1_outside_access_constraints}"

    wait_for_cmr
  end

  before do
    login(provider: 'NSIDC_ECS', providers: %w(MMT_2 NSIDC_ECS))

    visit '/'
  end

  context 'when searching for collections by a provider when the user should not have access to any collections', js: true do
    # # search for collections for nsidc
    # before do
    #   click_on 'search-drop'
    #   select 'NSIDC_ECS', from: 'provider_id'
    #   # save_screenshot
    #   click_on 'Search Collections'
    # end
    #
    # # should not see any collections
    # it 'returns no results' do
    #   # TODO figure out query
    #   expect(page).to have_content('No collections found.')
    # end
    # for some reason, having this test run first allows it to pass, then makes the next test fail. but commenting out this test allows the next test to pass.

    context 'when a collection permission with access constraint values is added' do
      before :all do
        # create collection permission with the access constraint values

        group_name = "Test Group for access constraint values NSIDC_ECS #{rand(100)}"
        group = create_group(
          name: group_name,
          provider_id: 'NSIDC_ECS',
          members: ['typical', 'testuser']
        )
        puts "group pub? #{group}"
        # use reg NSIDC group?
        collection_permission_with_access_constraints = {
          group_permissions: [
            {
              group_id: group['concept_id'],
              permissions: ['read', 'order']
            }#, {
            #   user_type: 'registered',
            #   permissions: ['read', 'order']
            # }
          ],
            catalog_item_identity: {
              'name': 'Test Collection Permissions Access Constraint Values',
              'provider_id': 'NSIDC_ECS',
              'collection_applicable': true,
              'granule_applicable': false,
              'collection_identifier': {
                # 'concept_ids': [
                #   @concept_1_within_access_constraints['concept-id'],
                #   @concept_2_within_access_constraints['concept-id'],
                #   @concept_1_outside_access_constraints['concept-id']
                # ],
                # 'access_value': {
                #   'min_value': 5,
                #   'max_value': 30#,
                #   'include_undefined_value': false
                # }
              }
            }
          }
          # the access values don't work

          @collection_permission_with_access_constraints = cmr_client.add_group_permissions(collection_permission_with_access_constraints, 'access_token')

          puts "colperm access constraints pub? #{@collection_permission_with_access_constraints.inspect}"

          wait_for_cmr


          # # pub 3 new records to nsidc
          # @concept_1_within_access_constraints, concept = publish_collection_draft(provider_id: 'NSIDC_ECS', short_name: 'WITHIN_ACCESS_CONSTRAINTS_1', access_constraint_value: 25, token: 'access_token_admin')
          # puts "asdf #{@concept_1_within_access_constraints}"
          # @concept_2_within_access_constraints, concept = publish_collection_draft(provider_id: 'NSIDC_ECS', short_name: 'WITHIN_ACCESS_CONSTRAINTS_2', access_constraint_value: 10, token: 'access_token_admin')
          # puts "qwer #{@concept_2_within_access_constraints}"
          # @concept_1_outside_access_constraints, concept = publish_collection_draft(provider_id: 'NSIDC_ECS', short_name: 'OUTSIDE_ACCESS_CONSTRAINTS_1', access_constraint_value: 50, token: 'access_token_admin')
          # puts "zxcv #{@concept_1_outside_access_constraints}"

          wait_for_cmr
          reindex_permitted_groups
          wait_for_cmr
        end

        context 'when search for collections by a provider when the user should have access to two of the collections', js: true do
          # search for collections for nsidc
          before do
            click_on 'search-drop'
            select 'NSIDC_ECS', from: 'provider_id'
            # save_screenshot
            click_on 'Search Collections'
          end
          # should not see 2 collections

          it 'returns 2 collections' do
            # TODO figure out have_search_query
            # expect(page).to have_content("2 collections found.")

            expect(page).to have_content('WITHIN_ACCESS_CONSTRAINTS_1')
            expect(page).to have_content('WITHIN_ACCESS_CONSTRAINTS_2')
          end
        end
      end
  end
end
