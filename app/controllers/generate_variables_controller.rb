class GenerateVariablesController < ManageVariablesController
  def naive

    request_size = params[:size]

    options = {}
    options[:collection_id] = params[:collection_id]
    options[:file_type] = request_size

    # response = if request_size == 'max'
    #              cmr_client.post_max_uvg(options)
    #            else
    #              cmr_client.post_small_uvg(options)
    #            end

    response = cmr_client.post_max_uvg(options)
    # fail

    render json: response.body
  end
end
