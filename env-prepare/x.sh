upgradeDM(){
  url="${1}"

  filename_1=$(basename "${url%\?*}")
  filename_2=$(echo -n $filename_1 | sed 's/\\/\\\\/g;s/\(%\)\([0-9a-fA-F][0-9a-fA-F]\)/\\x\2/g')"\n"
  filename_3=$(printf  $filename_2)
  filename=$(echo $filename_3 | sed 's/.tar.gz//g')

  echo "Filename: $filename"

  curl -o  cache.tar.gz $url
  tar zxvf cache.tar.gz
  rm -rf   cache.tar.gz

  pm2 del all

  cd ./"$filename"

  rm -rf                        /usr/gcxh-dm/platform/service/*
  mv ./service/*                /usr/gcxh-dm/platform/service/

  rm -rf                        /usr/gcxh-dm/platform/website/*
  mv ./website/*                /usr/gcxh-dm/platform/website/

  rm -rf                        /usr/gcxh-dm/platform/igniter
  mv ./igniter                  /usr/gcxh-dm/platform/

  rm -rf                        /usr/gcxh-dm/platform/igniter.yml
  mv ./igniter.yml              /usr/gcxh-dm/platform/

  cd ../
  rm -rf ./"$filename"

  cd /usr/gcxh-dm/platform

  ./igniter --start
}

