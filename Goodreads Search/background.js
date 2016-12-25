  function resetDefaultSuggestion() {
    chrome.omnibox.setDefaultSuggestion({
    description: 'gr: Search goodreads for %s'
    });
  }
  resetDefaultSuggestion();
  
  function navigate(url) {
    chrome.tabs.query({active: true, currentWindow: true}, function(tabs) {
    chrome.tabs.update(tabs[0].id, {url: url});
    });
  }
  
  chrome.omnibox.onInputEntered.addListener(function(text) {
    navigate("http://www.goodreads.com/search/search?q=" + text + "&group_id=&search_type=books&commit=search");
  });
