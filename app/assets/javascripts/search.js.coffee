$ ->
  $('.search-activator').autocomplete({
    serviceUrl: '/search'
    groupBy: 'category'
    triggerSelectOnValidInput: false
    showNoSuggestionNotice: true
    onSelect: (suggestion) ->
      if(suggestion.data.category == 'Category')
        window.location.replace("/categories/" + suggestion.value);
      else if(suggestion.data.category == 'User')
        window.location.replace("/channel/" + suggestion.value);
      else if(suggestion.data.category == 'Channel')
        window.location.replace("/channel/" + suggestion.data.user_id);

      return
  })
