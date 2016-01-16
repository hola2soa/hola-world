# Hola Service [ ![Codeship Status for hola2soa/hola-world](https://codeship.com/projects/5a6c37d0-788e-0133-9d23-42fad4cc0ef7/status?branch=master)](https://codeship.com/projects/118585)

Take a look: <a href="https://hola2soa-web.herokuapp.com/" target="_blank">live site</a>


This site serves as an interface to the <a href="https://wss-dynamo.herokuapp.com/" target="_blank">api</a>. The purpose of the site is to help women consolidate the "hunting" of items in one place. There are three websites, namely, <a href="http://www.queenshop.com/" target="_blank">Queenshop</a>, <a href="http://www.joyceshop.com/" target="_blank">Joyceshop</a>, and <a href="http://www.stylemooncat.com/" target="_blank">StyleMoonCat</a> that have similar features allowing women to shop online. User can pinned items for future look. The Api contains end points to gems that scrape these sites on user demand. Once the the information have been scraped the data is cached to improve response time on subsequent requests of the same query.

Also, we implement a price range selector on the top for more fine-grained search.

Handles:
- GET   / redirects to /show
  - /show
    - displays the dashboard
  - /show/new_items
   - show the newest items
  - /show/\<item name\>
    - searches for item and displays a list of items matching name with their respective price
    - if item match category ,it will search by category
  - /show/\<category name\>
    - searches for item and displays a list of items matching name with their respective price
    - if item match category ,it will search by category  
  - /show/pinned_items  
    - show the user pinned items
  - /search?price=\<lower bound of price\>%2C700\<upper bound of price\>&keyword=\<ketword\>&submit=Search
    - work in progress, allow user to filter items by price and keyword
