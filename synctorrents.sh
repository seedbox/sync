#!/bin/sh
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

if [ -e synctorrent.lock ]
then
	echo "Synctorrent is running already."
	exit 1
else
	touch synctorrent.lock
	lftp -p 22 -u $login,$pass sftp://$host << EOF
	set mirror:use-pget-n 3
	mirror -c -P5 --log=movies-sync.log --Remove-source-files $remote_movies $local_movies
	mirror -c -P5 --log=tvshows-sync.log --Remove-source-files $remote_tvshows $local_tvshows
	mirror -c -P5 --log=music-sync.log --Remove-source-files $remote_music $local_music
	mirror -c -P5 --log=other-sync.log --Remove-source-files $remote_other $local_other
	quit
EOF

	### Do any XBMC / Plex updates here ###

	# Update XBMC libraries
	# (see http://kodi.wiki/view/HOW-TO:Remotely_update_library)
	#
	# curl --data-binary '{ "jsonrpc": "2.0", "method": "VideoLibrary.Scan", "id": "mybash"}' /
	#      -H 'content-type: application/json;' http://localhost:9191/jsonrpc
	# curl --data-binary '{ "jsonrpc": "2.0", "method": "AudioLibrary.Scan", "id": "mybash"}' /
	#	   -H 'content-type: application/json;' http://localhost:9191/jsonrp

	# Update Plex libraries
	# (see https://support.plex.tv/hc/en-us/articles/201242707-Plex-Media-Scanner-via-Command-Line)
	#
	# "C:\Program Files (x86)\Plex\Plex Media Server\Plex Media Scanner.exe" --scan --refresh --force --section 29
	# or
	# wget -q --delete-after "http://127.0.0.1:32400/library/sections/1/refresh" > /dev/null

	rm -f synctorrent.lock
	exit 0
fi

