// goodreads-search-user.js
// ==UserScript==
// @name         Goodreads Search
// @version      0.1
// @description  Tampermonkey script for linking amazon to goodreads
// @author       vgk7
// @include      *://www.amazon.*
// @grant        none
// ==/UserScript==

(function () {
    'use strict';

    var searchUrl;
    var re=/([\/-]|is[bs]n=)(\d{7,9}[\dX])/i;
    var url = window.location.href;   
    if(re.test(location.href)===true){
        var isbn = RegExp.$2;        
        searchUrl = 'http://www.goodreads.com/search/search?q='+isbn+'&group_id=&search_type=books&commit=search';
    }
    else if (url.match("/([a-zA-Z0-9]{10})(?:[/?]|$)")) {
        var asin = url.match("/([a-zA-Z0-9]{10})(?:[/?]|$)")[1];
        searchUrl = 'http://www.goodreads.com/search/search?q='+asin+'&group_id=&search_type=books&commit=search';
    }
    else {
        var title = document.evaluate("//span[@id='ebooksProductTitle']", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.textContent;
        searchUrl = 'http://www.goodreads.com/search/search?q='+title.replace(/ /g, '+')+'&group_id=&search_type=books&commit=search';
    }
    var div = document.getElementById('averageCustomerReviews');
    div.innerHTML = div.innerHTML + '<br> <a href=' + searchUrl + '> Goodreads Reviews</a>';
})();
