if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi

gpg --quiet --batch --yes --decrypt --passphrase="$FIREBASE_DECRYPTION_SECRET" --output firebase_configs.tar.gz firebase_configs.tar.gz.gpg 
tar xvf firebase_configs.tar.gz
rm firebase_configs.tar.gz