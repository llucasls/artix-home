#!/bin/sh
set_wallpaper() {
	local wallpaper="$1"
	if test -n "${wallpaper}"; then
		feh --no-fehbg --bg-scale "${wallpaper}" &
	fi
}

enable_service() {
	local service_dir="${XDG_RUNTIME_DIR}/service"
	local service_unit="${HOME}/.repos/runit-service/sv/$1"
	mkdir -p "${service_dir}"
	ln -sft "${service_dir}" "${service_unit}"
}

main() {
	setxkbmap -layout br -model abnt2 &
	xdotool key Num_Lock &

	enable_service emacs &

	if test $(tty) = /dev/tty2; then
		picom &
		dwm-status-bar &
		set_wallpaper "${WALLPAPER}" &
		exec start-session -p "${FISH_PID}" dwm
	elif test $(tty) = /dev/tty3; then
		exec start-session -p "${FISH_PID}" mate-session
	fi

	picom &
	dwm-status-bar &
	set_wallpaper "${WALLPAPER}" &
	exec dwm
}

main
