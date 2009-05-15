Bananajour - Local git publication and collaboration
====================================================

Local git repository hosting with a sexy web interface and bonjour discovery. It's like a adhoc, local, network-aware github!

Unlike gitjour the repositories you're serving are not your working git repositories, you can publish projects from any directory and it has a sexy web interface.

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
    
Initialize a new bananjour repository:

    cd ~/code/myproj
    bananajour init

Publish your codez:

    git push banana master

Fire up [http://localhost:90210/](http://localhost:90210/) to check it out.

If somebody starts sharing a bananajour repository with the same name on the
network it'll automatically show up in the network thanks to the wonder that is bonjour.

Official repository and support
-------------------------------

[http://github.com/toolmantim/bananajour](http://github.com/toolmantim/bananajour) is where Bananajour lives along with all of its support issues.

Props
-----

[Carla Hackett](http://carlahackettdesign.com/) for the rad logo.

License
-------

All directories and files are MIT Licensed.