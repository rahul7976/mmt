class GenerateVariablesController < ManageVariablesController
  def naive
    method = params[:method]

    # options = { payload: {} }
    payload = {}
    payload[:collection_concept_id] = params[:collection_id]
    # options[:file_type] = request_size
    payload[:provider] = current_user.provider_id

    # payload[:test] = 'test'
    payload[:granule_uri] = 'some.granule.uri'

    # options = { payload: payload }
    response = cmr_client.post_uvg_naive({ payload: payload })

    render json: response.body
  end

  def augment
    augment_type = params[:augment_type]

    payload = {}
    payload[:collection_concept_id] = params[:collection_id]
    payload[:provider] = current_user.provider_id
    file_path = File.join(Rails.root, 'lib', 'stubs', 'stub_variable.json')
    json_vars = File.read(file_path)
    vars = JSON.parse(json_vars)
    payload[:variables] = vars
    # payload[:granule_uri] = 'some.granule.uri'

    options = { payload: payload }
    response = cmr_client.send("uvg_augment_#{augment_type}_stub", options)

    render json: response.body
  end
end
