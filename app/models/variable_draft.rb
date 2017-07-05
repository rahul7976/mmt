# :nodoc:
class VariableDraft < Draft
  before_create :set_searchable_fields

  class << self
    def forms
      []
    end
  end

  def set_searchable_fields
    self.short_name = draft['Name']
    self.entry_title = draft['LongName']
  end
end