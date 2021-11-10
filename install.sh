#!/bin/sh

echo "Welcome to the Plugz installer!"

jq_version="1.6"
jq_source_ipfs=
jq_source_gitlab=
jq_source_github="https://github.com/stedolan/jq.git"
jq_windows_amd64_ipfs="bafybeickx63eoatrhtce66oostzhlqqbq37rjg2x5w47ngy64hpkrbjqyy"
jq_linux_i386_ipfs="bafybeiam4vrjvfcb67g4xeajlbtsxsjv6x5jeql4z3jvraqij2lmykup4q"
jq_linux_amd64_ipfs="bafybeifegjcgvlgriihsumhlyzqltyq4hgwmfxzmyp7tpnhjqsfpc3zgjm"
jq_osx_amd64_ipfs="bafybeicf7q6f4c37euy6owy62demclayuzd6lahcen2vkfps7sr3ufvdra"

echo "Installing dependency: jq..."
mkdir include
mkdir include/jq
mkdir include/jq/$jq_version
# download using recipe.sh
if [ "$(uname -m)" = "i386" ] || [ "$(uname -m)" = "i686" ] || [ "$(uname -m)" = "x86_32" ]; then
   wget https://ipfs.io/ipfs/$jq_linux_i386_ipfs -O ./include/jq/$jq_version/jq-linux32.tar.gz
   echo "Checking for package integrity..."
   if [ "$(ipfs add -q --only-hash ./include/jq/$jq_version/jq-linux32.tar.gz | ipfs cid base32)" = "$jq_linux_i386_ipfs" ]
      then
         echo "CID/Hash is the same from requested and the downloaded file, so the download is ok."
         tar -xzf include/jq/$jq_version/jq-linux32.tar.gz
      else
         echo "Requested CID/Hash $jq_linux_i386_ipfs is different from the result: $(ipfs add -q ./include/jq/$jq_version/jq-linux32.tar.gz). Your download is corrupt. Please try again."
fi
fi
if [ "$(uname -m)" = "amd64" ] || [ "$(uname -m)" = "x86_64" ]; then
   wget https://ipfs.io/ipfs/$jq_linux_amd64_ipfs -O ./include/jq/$jq_version/jq-linux64.tar.gz
   echo "Checking for package integrity..."
   if [ "$(ipfs add -q --only-hash ./include/jq/$jq_version/jq-linux64.tar.gz | ipfs cid base32)" = "$jq_linux_amd64_ipfs" ]
      then
         echo "CID/Hash is the same from requested and the downloaded file, so the download is ok."
         tar -xzf include/jq/$jq_version/jq-linux64.tar.gz
      else
         echo "Requested CID/Hash $jq_linux_amd64_ipfs is different from the result: $(ipfs add -q ./include/jq/$jq_version/jq-linux64.tar.gz). Your download is corrupt. Please try again."
fi
fi

echo "Now installing jq..."
sudo mv jq /usr/bin
chmod +x /usr/bin/jq
echo "Testing if jq works:"
jq

echo "Installing Plugz..."

echo "- Copying (probably) a lot of files. Don't worry if it takes several times..."
sudo mkdir /usr/lib/plugz
sudo cp -r -f --preserve=all . /usr/lib/plugz

echo "- Installing Plugz in /usr/bin..."
sudo cat > /usr/bin/plugz << ENDOFFILE
#!/bin/bash

source /usr/lib/plugz/plugz
ENDOFFILE

echo "- Turning Plugz into a executable..."
chmod 755 /usr/bin/plugz && sudo chmod +x /usr/bin/plugz

sudo rm /usr/lib/plugz/install.sh # no need anymore to use the installer again

echo "Done! Run 'plugz' command to use it."
