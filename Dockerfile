FROM jdonavan/steambase
MAINTAINER Donavan Stanley <donavan.stanley@gmail.com>

# Query port for Steam's server browser
EXPOSE  27015/udp 

# Game client port
EXPOSE 7777/udp

# RCON for remote console server access
EXPOSE 32330

USER root
RUN echo "fs.file-max=100000" >>  /etc/sysctl.conf
RUN echo "* soft nofile 100000" >> /etc/security/limits.conf
RUN echo "* hard nofile 100000" >> /etc/security/limits.conf
RUN echo "session required pam_limits.so" >> /etc/pam.d/common-session


# From here on out we shouln't be root
USER steam

# This is a cheezy way to force a rebuild every time they bump version numbers
RUN echo "195" > /opt/steam/servers/ark_server_version.txt

# Install the server
RUN /home/steam/steamcmd/steamcmd.sh  +login anonymous +force_install_dir "/opt/steam/servers/ark" +app_update 376030 validate +quit

# Use the save folder on our VOLUME
RUN ln -s  /opt/steam/save/ /opt/steam/servers/ark/ShooterGame/Saved


# Launch the server as our command
CMD ["/opt/steam/servers/ark/ShooterGame/Binaries/Linux/ShooterGameServer", "TheIsland?listen", "-server" ,"-log"]


