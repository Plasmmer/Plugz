#!/bin/sh

jq_source_ipfs=
jq_source_dat="53e5f5c0507a0810ae1bbf513c9789c95c243dd93013f4bf76ad40172a55e199"
jq_source_gitlab=
jq_source_github="https://github.com/stedolan/jq.git"
jq_windows_amd64_ipfs="QmTNSRudeAJUdNZVKc3wVucAmsrG1qSpb9dKwev4vSXKos"
jq_linux_i386_ipfs="QmPCzUHmgQrL5cyD2sfttYEzkLuNaP89iXAQSWmQNstAao"
jq_linux_amd64_ipfs="QmZPc2cQh8LjYoSLjqg4Ust9aa5poVFWRX1e1jrxKks7wx"
jq_osx_amd64_ipfs="QmT3qvGpXhhgTi2pgtxjK9BNELUHmmKHvgXRJZ8eyBXbtb"

echo "Installing dependency: jq..."
mkdir include
mkdir include/jq
# download using recipe.sh
if [ "$(uname -m)" = "i386" ] || [ "$(uname -m)" = "i686" ]; then
   wget https://siderus.io/ipfs/$jq_linux_i386_ipfs -O ./include/jq/jq-linux32.tar.gz
   echo "Checking for package integrity..."
   if [ "$(ipfs add -q --only-hash ./include/jq/jq-linux32.tar.gz)" = "$jq_linux_i386_ipfs" ]
      then
         echo "CID/Hash is the same from requested and the downloaded file, so the download is ok."
         tar -xzf include/jq/jq-linux32.tar.gz
      else
         echo "Requested CID/Hash $jq_linux_i386_ipfs is different from the result: $(ipfs add -q ./include/jq/jq-linux32.tar.gz). Your download is corrupt. Please try again."
fi
fi
if [ "$(uname -m)" = "amd64" ]; then
   wget https://siderus.io/ipfs/$jq_linux_amd64_ipfs -O ./include/jq/jq-linux64.tar.gz
   echo "Checking for package integrity..."
   if [ "$(ipfs add -q --only-hash ./include/jq/jq-linux64.tar.gz)" = "$jq_linux_amd64_ipfs" ]
      then
         echo "CID/Hash is the same from requested and the downloaded file, so the download is ok."
         tar -xzf include/jq/jq-linux64.tar.gz
      else
         echo "Requested CID/Hash $jq_linux_amd64_ipfs is different from the result: $(ipfs add -q ./include/jq/jq-linux64.tar.gz). Your download is corrupt. Please try again."
fi
fi

echo "Now installing jq..."
sudo mv jq /usr/bin
chmod +x /usr/bin/jq
echo "Testing if jq works:"
jq

echo "Installing Plugzlr..."
sudo cp -f plugzlr /usr/bin && sudo chmod +x /usr/bin/plugzlr
echo "Done! Run 'plugzlr' command to use it."
