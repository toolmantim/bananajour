# Bananajour

Local git repository hosting with a sexy web interface and bonjour discovery. It's like a adhoc, local, network-aware github!

Unlike gitjour the repositories you're serving are not your working git repositories, you can publish projects from any directory and it has a sexy web interface.

## Installation

    gem install bananajour

## Getting started

Start it up:

    bananajour
    
to initialize a new bananjour repository:

    cd ~/code/myproj
    bananajour init

and publish your codez:

    git push banana master

Fire up [http://localhost:90210/](http://localhost:90210/) to check it out.

If somebody starts sharing a bananajour repository with the same name on the
network it'll automatically show up in the network.

## Supported configurations

* Mac OS X - Ruby 1.8.6
* others? (need testers!)

## Official repository and support

[http://github.com/toolmantim/bananajour](http://github.com/toolmantim/bananajour) is where Bananajour lives along with all of its support issues.

## Props

[Carla Hackett](http://carlahackettdesign.com/) for the rad logo.

## License

All directories and files are MIT Licensed except for public/logo.png which is All Rights Reserved.