set -eu

video=$1
fallback=$2
shift 2

if [ -r "$video" ] && [ -s "$video" ]; then
    wallpaper=$video
else
    printf 'CoplandOS: vídeo indisponível; usando o wallpaper estático.\n' >&2
    wallpaper=$fallback
fi

exec "$@" --auto-stop ALL "$wallpaper"
