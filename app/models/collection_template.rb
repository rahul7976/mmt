class CollectionTemplate < Template
  include CollectionDraftsHelper

  class << self
    def create_template(draft, user, name)
      template = CollectionTemplate.new do |temp|
        temp.draft = draft.draft
        temp.user = user
        temp.entry_title = draft.entry_title
        temp.template_name = name
        temp.provider_id = user.provider_id
        temp.short_name = draft.short_name
      end
      template.save
      template
    end

    def forms
      CollectionDraftsHelper::DRAFT_FORMS
    end

    def get_next_form(name, direction)
      delta = direction == 'Next' ? 1 : -1
      index = DRAFT_FORMS.index(name)
      DRAFT_FORMS[index + delta] || DRAFT_FORMS.first
    end
  end
end