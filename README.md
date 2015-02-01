# LFTP seedbox sync script

A simple script to download new media from your seedbox every night.  It will download contect from the server (overwriting any local duplicates) and delete it from the server once the download is complete.

### Requirements:
- LFTP, an awesome command line FTP utility
- A way to run bash scripts
- Cron
- A little bit of setup

If you are on windows, that means you'll need something like [cygwin](http://cygwin.com/install.html) or [babun](http://babun.github.io/) (which gets my vote).

### How to use:
1- Change script values. If you set up your seedbox with [this installer](https://github.com/seedbox/deploy) then you can leave the remote paths alone.

```sh
login="your_user"
pass="your_password"
host="your_server_address"

remote_movies="/home/movies"
remote_tvshows="/home/tv"
remote_music="/home/music"
remote_other="/home/other"

local_movies="/local/path/for/movies"
local_tvshows="/local/path/for/tv"
local_music="/local/path/for/music"
local_other="/local/path/for/other"
```

2- Set a cron job to run every day at night (I have mine set for 4am)

3 (Optional) - Set script to update your XBMC or Plex here:

```
### Do any XBMC / Plex updates here ###

# Update XBMC libraries
# (see http://kodi.wiki/view/HOW-TO:Remotely_update_library)

curl --data-binary '{ "jsonrpc": "2.0", "method": "VideoLibrary.Scan", "id": "mybash"}' /
     -H 'content-type: application/json;' http://localhost:9191/jsonrpc
curl --data-binary '{ "jsonrpc": "2.0", "method": "AudioLibrary.Scan", "id": "mybash"}' /
     -H 'content-type: application/json;' http://localhost:9191/jsonrp

# Update Plex libraries
# (see https://support.plex.tv/hc/en-us/articles/201242707-Plex-Media-Scanner-via-Command-Line)

"C:\Program Files (x86)\Plex\Plex Media Server\Plex Media Scanner.exe" --scan --refresh --force --section 1
```