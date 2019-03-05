class VariableAssociationsController < CmrSearchController
  def index
    @concept_id = params[:collection_id] || params[:id]
    @revision_id = params[:revision_id]

    headers = { 'Accept' => "application/#{Rails.configuration.umm_c_version}; charset=utf-8" }
    response = cmr_client.get_concept(@concept_id, token, headers, @revision_id)
    render text: response.body

    # @service = if service_concept_response.success?
    #              service_concept_response.body
    #            else
    #              Rails.logger.error("Error retrieving concept for Service #{@concept_id} in `set_service`: #{service_concept_response.clean_inspect}")
    #              {}
    #            end
    #
    #
    #
    # render text: "hello"
  end
end