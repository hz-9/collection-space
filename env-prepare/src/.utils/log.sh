#!/bin/bash

startLog() {
  name=$1

  echo ""
  echo "Prepare ${name} installation package is starting..."
  echo ""
}

completeLog() {
  name=$1

  echo ""
  echo "Prepare ${name} installation package is Complete."
  echo ""
}
