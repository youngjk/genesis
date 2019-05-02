#!/bin/bash

# version of tesseract to launch
echo -e "Tesseract version:"
read version

if [[ "$version" == "v1" ]]; then
  pod=$(kubectl --context staging --namespace default get pods | grep -o "tesseract-[a-zA-Z0-9]\+-[a-zA-Z0-9]\+" | head -1 )
  kubectl --context staging --namespace default exec -it $pod /bin/bash
elif [[ "$version" == "v2" ]]; then
  pod=$(kubectl --context staging --namespace tesseract-v2 get pods | grep -o "tesseract-v2-[a-zA-Z0-9]\+-[a-zA-Z0-9]\+" | head -1 )
  kubectl --context staging --namespace tesseract-v2 exec -it $pod /bin/bash
else
  echo -e "Available versions: v1 | v2"
fi
