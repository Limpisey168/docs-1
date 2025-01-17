#!/bin/bash

set -o errexit
set -o nounset

echo "installing required tools..."
yarn install
npm install -g solidity-docgen@0.5.16

echo "installing protocol repo..."
git clone http://github.com/umaprotocol/protocol/ --single-branch || echo "Repo already exists"
yarn install --cwd protocol/packages/core --ignore-scripts

echo "generating docs files..."
cd protocol/
solidity-docgen --solc-module solc-0.8.9 -i packages/core/contracts/ -t ../ci/ -o temp-docs/

echo "configuring docs..."
mv temp-docs/ ../docs/contracts

contracts_file="../docs/contracts/Contracts.md"
touch $contracts_file

cat << EOF > $contracts_file
 ### Contracts documentation

 The sidebar displays an autogenerated list of UMA smart contracts.
EOF
