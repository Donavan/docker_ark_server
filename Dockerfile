FROM jdonavan/steambase
MAINTAINER Donavan Stanley <donavan.stanley@gmail.com>

# Query port for Steam's server browser
EXPOSE  27015/udp 

# Game client port
EXPOSE 7777/udp

# RCON for remote console server access
EXPOSE 32330

