#!/usr/bin/env bash

function connect {
  DONE=no
  name=$1
  ancestor=$2
  networks=$3

  while [ $DONE == "no" ]
  do
    CID=$(docker ps -q -f ancestor=$ancestor)
    if [ $CID ]
    then
      # Go over the networks that we wish the container is connected to
      for network in $networks
      do
        # Get list of containers connected to $network
        CIDS=$(docker network inspect -f "{{.Containers}}" $network)
        if [[ $CIDS =~ $CID ]] # If the container id is present in the network's container list
        then
          echo "==> $name container already connected to $network network"
        else
          docker network connect $network $CID # connect container $CID to network $network
          echo "==> $name container successfully connected to network $network"
        fi
      done

      DONE=yes

      echo "==> $name container connected to networks"
    else
      echo "* $name container not yet available"
    fi
  done

  echo "==> done"
}

connect front-end weaveworksdemos/front-end "secure internal external"
connect orders weaveworksdemos/orders "internal secure backoffice"
