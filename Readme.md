Bananajour - Local git publication and collaboration
====================================================


Via the [best reddit comment ever written](http://www.reddit.com/r/programming/comments/9txsd/git_bonjour_bananajour_version_22_released/c0efrxz):

> The logo is the fucking business. The mustache just bring[s] it to a whole
> other level.

Bananajour is local git repository hosting with a friendly web interface and Bonjour discovery. It's like a bunch of adhoc, local, network-aware githubs!

Unlike Gitjour, the repositories you're serving are not your working git repositories, they're served from `~/.bananajour/repositories`. You can push to your bananajour repositories from your working copies just like you do with github.

![Screenshot of local view of Bananajour 2.1.3](https://github.com/toolmantim/bananajour/raw/master/screenshot.png)

Purpose
-------

Hosting/sharing git repos is painful. This is the core value that github originally solved. When you don't have internet access, say at railscamp, then bananajour allows for discovery and read-only access of projects. - @drnic

Installation and usage
----------------------

You'll need at least [git version 1.6](http://git-scm.com/). Run `git --version` if you're unsure.

Install it from [gemcutter](http://gemcutter.org/) via gems:

    gem install bananajour

(you might need to do a `gem sources -a http://gemcutter.org` beforehand!)

Start it up:

    bananajour

Go into an existing project and add it to bananajour:

    cd ~/code/myproj
    bananajour add

Publish your codez:

    git push banana master

Fire up [http://localhost:9331/](http://localhost:9331/) to check it out.

If somebody starts sharing a Bananajour repository with the same name on the
network it'll automatically show up in the network thanks to the wonder that is Bonjour.

For a list of all the commands:

    bananajour help

Optional configuration: you can override the hostname by setting a global git config option like so:

    git config --global bananajour.hostname foobar

If you set this setting, then bananajour will assume that you know precisely what you're doing, it will not append .local, it will not check this hostname is valid, or do anything to it.  If you set this, then you're on your own.

Linux support
-------------

To install the dnssd gem on Linux you'll need [avahi](http://avahi.org/). For Ubuntu peeps this means:

    sudo aptitude update

    sudo aptitude install g++ ruby-dev \
     libavahi-compat-libdnssd-dev avahi-discover avahi-utils

and you'll need to set the domain-name:

    sudo sed -i \
     -e 's/#domain-name=local/domain-name=local/' \
     /etc/avahi/avahi-daemon.conf

    sudo service avahi-daemon restart

You can debug whether or not Avahi can see Bananajour and git-daemon Bonjour statuses using the command 'avahi-browse'.  This command can be found in the package 'avahi-utils'.

The following command will show you all of the Bonjour services running on your local network:

    avahi-browse --all

If you kill bananajour with kill -9 it doesn't get a chance to unregister the Bonjour services, and when it is restarted it will die with DNSSD::AlreadyRegisteredError.  Although not ideal, you can work around this my restarting avahi-daemon first.

Note: You might have to restart the avahi-daemon sometimes if you are having problems seeing other bananajours.

Official repository and support
-------------------------------

The official repo and support issues/tickets live at [github.com/toolmantim/bananajour](http://github.com/toolmantim/bananajour).

Feature and support discussions live at [groups.google.com/group/bananajour](http://groups.google.com/group/bananajour).

Developing
----------

    bundle install
    rake -T

Contributors
------------

* [Carla Hackett](http://carlahackettdesign.com/) (logo)
* [Nathan de Vries](http://github.com/atnan)
* [Lachlan Hardy](http://github.com/lachlanhardy)
* [Josh Bassett](http://github.com/nullobject)
* [Myles Byrne](http://github.com/quackingduck)
* [Ben Hoskings](http://github.com/benhoskings)
* [Brett Goulder](http://github.com/brettgo1)
* [Tony Issakov](https://github.com/tissak)
* [Mark Bennett](http://github.com/MarkBennett)
* [Travis Swicegood](http://github.com/tswicegood)
* [Nate Haas](http://github.com/natehaas)
* [James Sadler](http://github.com/freshtonic)
* [Jason King](http://github.com/JasonKing)
* [Michael Pope](http://github.com/map7)

License
-------

All directories and files are MIT Licensed.

Warning to all those who still believe secrecy will save their revenue stream
-----------------------------------------------------------------------------
Bananas were meant to be shared. There are no secret bananas.
