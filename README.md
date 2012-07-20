npm\_proxy background
=====================

With the ever expanding disk requirements of the public npm repository
and the issues with constantly replicating the database (replication
stopping for no apparent reason, bandwidth limitations.. etc ),
something needed to be done.

Enter npm\_proxy.

npm\_proxy runs from squid proxy using the "url_rewrite_program" option. 

When it sees a http request for registry.npmjs.org, it fires of a LWP
request to that URL, if the URL returns 200, squid will process the
connection normaly.  If the LWP request sees a 404, it will re-write 
the URL to point it at an internal couchdb.  This allows for pushing of 
your private npm packages to your internal repo with out having to have 
all the dependent packages installed as well.

Squid3 Config
=============

````
url_write_program /usr/local/bin/npm_proxy.pl
````

NPMRC
=====

````
registry = http://registry.npmjs.org
proxy = http://proxyserver:3128
````

