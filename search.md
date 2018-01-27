---
title: "Search"
layout: docs
---

<form action="{{site.baseurl}}/search" method="get">
  <label for="search-box">Search</label>
  <input type="text" id="search-box" name="query">
  <input type="submit" value="Go">
</form>

<ul id="search-results"></ul>

<script src="{{site.baseurl}}/js/lunr.min.js"></script>
<script src="{{site.baseurl}}/js/searchPageIndex.js"></script>
<script src="{{site.baseurl}}/js/search.js"></script>
