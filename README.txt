Building locally
----------------

Install the jekyll Ruby module(s):

 [ >export GEM_HOME=~/.gem # if you don't have admin rights ]
   >gem install jekyll
   >gem install jekyll-paginate # for multipage blog listings
   >gem install jekyll-feed # for Atom (RSS-like) feed
   >gem install jekyll-sitemap # for web crawlers

Run jekyll in 'watch' mode to update as you modify files (restart if _config.yml
   changes):

   jekyll serve --watch --host=0.0.0.0 &

View the locally served page at:

  http://127.0.0.1:4000

0.0.0.0 tells jekyll to listen to all addresses, not just the local loopback,
meaning you can use your favorite tablet to view the site.

Overall site config
-------------------

   _data/settings.yml

Settings here include what to show on the landing page.


