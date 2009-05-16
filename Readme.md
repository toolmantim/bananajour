Bananajour - Local git publication and collaboration
====================================================

Local git repository hosting with a sexy web interface and Bonjour discovery. It's like adhoc, local, network-aware githubs!

Unlike Gitjour, the repositories you're serving are not your working git repositories. You can publish projects from any directory and each will be shown in the same hot web interface.

Bananajour was developed by [Tim Lucas](http://toolmantim.com/).

Requirements and Support
------------------------

So far it's only been tested with Mac OS 10.5 and Ruby 1.8.6. Any feedback and help to support linux and windows platforms would be much appreciated!

You'll need at least git version 1.6

Installation and usage
----------------------

    gem install bananajour

Start it up:

    bananajour
    
Initialize a new Bananajour repository:

    cd ~/code/myproj
    bananajour init

Publish your codez:

    git push banana master

Fire up [http://localhost:9331/](http://localhost:9331/) to check it out.

If somebody starts sharing a Bananajour repository with the same name on the
network, it'll automatically show up in the network thanks to the wonder that is Bonjour.

Requirements and Support
------------------------

So far it's only been tested with Mac OS 10.5 and Ruby 1.8.6. Any feedback and help to support Linux and Windows platforms would be much appreciated!

Official repository and support
-------------------------------

[http://github.com/toolmantim/bananajour](http://github.com/toolmantim/bananajour) is where Bananajour lives along with all of its support issues.

Props
-----

[Carla Hackett](http://carlahackettdesign.com/) for the rad logo.

License
-------

All directories and files are MIT Licensed.

Warning to all those who still believe secrecy will save their revenue stream
-----------------------------------------------------------------------------
Bananas were meant to be shared. There are no secret bananas.
