#!/bin/bash
git pull
cd website
npm install
npm run build
mv build ../firebase/
cd ../firebase/
rm -rf hosting
mv build/ hosting
firebase deploy --only hosting

