#!/bin/bash

# Verifica che le variabili d'ambiente siano impostate
if [ -z "$ACCESS_KEY_ID" ] || [ -z "$SECRET_ACCESS_KEY" ]; then
  echo "ACCESS_KEY_ID e SECRET_ACCESS_KEY devono essere impostati."
  exit 1
fi

# Imposta le credenziali per s3fs
echo "$ACCESS_KEY_ID:$SECRET_ACCESS_KEY" > /etc/passwd-s3fs
chmod 600 /etc/passwd-s3fs

# Array dei bucket da montare
declare -a arr=("cygno-data" "cygno-sim" "cygno-analysis")

# Loop attraverso l'array
for i in "${arr[@]}"
do
  DIR="/home/root/s3/$i"
  echo "Mounting $DIR"
  
  # Smonta il punto di montaggio se già utilizzato
  if mountpoint -q "$DIR"; then
    fusermount -u "$DIR"
  fi

  # Crea la directory se non esiste
  if [ ! -d "$DIR" ]; then
    mkdir -p "$DIR"
  fi
  
  chown $UID:$GID "$DIR"
  
  # Monta il bucket S3
  s3fs "$i" "$DIR" -o passwd_file=/etc/passwd-s3fs -o url=https://swift.recas.ba.infn.it/ -o use_path_request_style -o umask=0007,uid=$UID,gid=$GID,allow_other # -o use_cache=/tmp/ -o ensure_diskfree=2G
  
  # Verifica se il montaggio è riuscito
  if mountpoint -q "$DIR"; then
    echo "Successfully mounted $DIR"
  else
    echo "Failed to mount $DIR"
  fi
done

# Loop infinito per mantenere il container attivo
while true
do
  mount | grep ^s3fs
  sleep 300
done
