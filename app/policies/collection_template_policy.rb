class CollectionTemplatePolicy < CollectionDraftPolicy
  def create_draft?
    user.user.provider_id == target.provider_id
  end
end