comparePermissionRevisions = (revisions1, revisions2) ->
  $modal = $('#check-permissions-table-revisions-modal')
  $modalText = $modal.find('.permissions-table-revisions-text')
  # debugger
  # if revisions1 == revisions2
  if JSON.stringify(revisions1) == JSON.stringify(revisions2)
    # there is no difference
    # modal should say there is no difference
    console.log 'revisions are the same'
    $modalText.text 'ACLs have not changed since editing of table began'
    $modal.show()

  # iterate through
  else

    differentTargets = []
    oldRevisions = Object.assign(revisions1)
    newRevisions = Object.assign(revisions2)

    $.each(revisions1, (key, value) ->
      if revisions2[key] == value
        console.log "#{key} matches, should be deleted"
        delete oldRevisions["#{key}"]
        delete newRevisions["#{key}"]
        # debugger
    )
    # differentTargets.push(Object.keys(revisions1))
    # differentTargets.push(Object.keys(revisions2))
    differentTargets = $.merge(Object.keys(oldRevisions), Object.keys(newRevisions))
    console.log 'differentTargets'
    console.log JSON.stringify(differentTargets)
    $modalText.text "The following ACLs have changed since you started editing this table: #{differentTargets.join(", ")}"
    $modal.show()


$(document).ready ->
  if $('.provider-permissions-table').length > 0
    $('#check-permissions-table-revisions-modal').leanModal
      top: 200
      overlay: 0.6
      closeButton: '.modal-close'

    $('#check-permissions-table-revisions').on 'click', (e) ->
      # e.preventDefault()
      console.log 'checking revisions'

      # 1. make a call to grab current page's permissions targets and revisions
      table_permission_revisions = window.all_provider_permission_revisions
      console.log 'revisions as on table'
      console.log JSON.stringify(table_permission_revisions)

      # 2. make a call to grab provider permissions (and get just revisions?) from controller
      $.ajax
        url: '/permissions_list'
        method: 'get'
        dataType: 'json'

        success: (data, status, xhr) ->
          new_permission_revisions = data
          console.log 'newly grabbed revisions'
          console.log JSON.stringify(new_permission_revisions)
          # debugger

          comparePermissionRevisions(table_permission_revisions, new_permission_revisions)
      # compare
