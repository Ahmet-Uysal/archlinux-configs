#!/bin/bash

STATE_FILE="/tmp/waybar_scroll_state"
MAX_LENGTH=20

# Metadata al
title=$(playerctl metadata title 2>/dev/null)
artist=$(playerctl metadata artist 2>/dev/null)
status=$(playerctl status 2>/dev/null)

# Hata kontrolü
if [[ -z "$title" ]]; then
  echo '{"text": "No song playing"}'
  exit 0
fi

full_text="$artist - $title"

# Başlat/Durdur ikon
if [ "$status" = "Playing" ]; then
  icon="⏸️"
else
  icon="▶️"
fi

# Eğer 20 karakterden kısa ise direkt göster
if [[ ${#full_text} -le $MAX_LENGTH ]]; then
  display_text="$full_text"
else
  # State file yoksa oluştur
  if [[ ! -f "$STATE_FILE" ]]; then
    echo 0 > "$STATE_FILE"
  fi

  # Pozisyon oku ve arttır
  pos=$(<"$STATE_FILE")
  pos=$((pos + 1))

  # En son pozisyondan sonra başa dön
  if (( pos > ${#full_text} )); then
    pos=0
  fi

  echo "$pos" > "$STATE_FILE"

  # Kayan metni hazırla
  display_text="${full_text:$pos:$MAX_LENGTH}"

  # Gerekirse başa sarmak için boşluk ekle
  if (( pos + MAX_LENGTH > ${#full_text} )); then
    overflow=$((pos + MAX_LENGTH - ${#full_text}))
    display_text+="${full_text:0:$overflow}"
  fi
fi

echo "{\"text\": \"⏮️ $icon ⏭️  $display_text\"}"

