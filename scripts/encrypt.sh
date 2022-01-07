if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi

# tar -czvf name-of-archive.tar.gz /path/to/directory-or-file
tar -czvf firebase_configs.tar.gz ios/GoogleService-info.plist android/app/google-services.json
gpg -c --batch --passphrase="$FIREBASE_DECRYPTION_SECRET" firebase_configs.tar.gz