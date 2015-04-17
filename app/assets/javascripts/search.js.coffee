$ ->
  $('#search').autocomplete({
    serviceUrl: '/search'
    groupBy: 'category'
    onSelect: (suggestion) ->
      alert 'You selected: ' + suggestion.value + ', ' + suggestion.data
      return
  })