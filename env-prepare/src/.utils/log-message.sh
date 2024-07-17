#!/bin/bash

printPrepareLogMessage() {
  softwareName=$1

  echo ""
  echo "Prepare ${softwareName} installation package is preparing..."
  echo ""
}

printCompleteLogMessage() {
  softwareName=$1

  echo ""
  echo "Prepare ${softwareName} installation package is Complete."
  echo ""
}
