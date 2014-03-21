# [Cozy](http://cozy.io) WebDAV

Cozy WebDAV allows you to synchronize your Contacts and your Calendars from
your Cozy with any device or software that supports CalDAV and CarDAV
protocols.

## Install

We assume here that the Cozy platform is correctly [installed](http://cozy.io/host/install.html)
 on your server.

You can simply install the WebDAV application via the app registry. Click on ythe *Chose Your Apps* button located on the right of your Cozy Home.

From the command line you can type this command:

    cozy-monitor install webdav


## Contribution

You can contribute to the Cozy WebDAV in many ways:

* Pick up an [issue](https://github.com/mycozycloud/cozy-webdav/issues?state=open) and solve it.
* Translate it in [a new language](https://github.com/mycozycloud/cozy-webdav/tree/master/client/app/locales).
* Allow to sync only contacts with a given tag.
* Allow to sync only calendars with a given tag.


## Hack

Hacking the WebDAV app requires you [setup a dev environment](http://cozy.io/hack/getting-started/). Once it's done you can hack Cozy Contact just like it was your own app.

    git clone https://github.com/mycozycloud/cozy-webdav.git

Run it with:

    node server.js

Each modification of the server requires a new build, here is how to run a
build:

    cake build


## Tests

![Build
Status](https://travis-ci.org/mycozycloud/cozy-webdav.png?branch=master)

To run tests type the following command into the Cozy WebDAV folder:

    cake tests

In order to run the tests, you must only have the Data System started.

## Icons

by [iconmonstr](http://iconmonstr.com/)

## License

Cozy WebDAV is developed by Cozy Cloud and distributed under the AGPL v3 license.

## What is Cozy?

![Cozy Logo](https://raw.github.com/mycozycloud/cozy-setup/gh-pages/assets/images/happycloud.png)

[Cozy](http://cozy.io) is a platform that brings all your web services in the
same private space.  With it, your web apps and your devices can share data
easily, providing you
with a new experience. You can install Cozy on your own hardware where no one
profiles you.

## Community

You can reach the Cozy Community by:

* Chatting with us on IRC #cozycloud on irc.freenode.net
* Posting on our [Forum](https://groups.google.com/forum/?fromgroups#!forum/cozy-cloud)
* Posting issues on the [Github repos](https://github.com/mycozycloud/)
* Mentioning us on [Twitter](http://twitter.com/mycozycloud)
