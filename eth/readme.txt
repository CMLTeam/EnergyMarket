Truffle + WebPack
Init:           truffle init webpack
Compile:        truffle compile
Migrate:        truffle migrate
Test:           truffle test
Build Frontend: npm run build
Run Linter:     npm run lint
Run Dev Server: npm run dev


Useful Shit:


airalab useful contracts:
https://github.com/airalab/core/tree/master/contracts

truffle:
https://truffle.readthedocs.io/en/develop/

geth:
https://github.com/ethereum/go-ethereum/wiki/Command-Line-Options

Azure Quickstart Templates:
https://github.com/Azure/azure-quickstart-templates/tree/master/go-ethereum-on-ubuntu

MS BlockChain Intensive resources:
https://github.com/Jiycefer/BlockchainIntensive2017/blob/master/README.md

Youtube Video:
https://www.youtube.com/watch?v=8jI1TuEaTro
https://www.youtube.com/watch?v=3-XPBtAfcqo

ERC20 Ethereum Token Standart
https://theethereum.wiki/w/index.php/ERC20_Token_Standard

Real Estate Use Case on Azure
https://github.com/bashalex/devcon

Dive into Ethereum:
https://habrahabr.ru/post/327236/

Run MetaCoin example:
to get balance:
MetaCoin.deployed().then(m=>m.getBalance.call('0xed8abc31bc3b8d9d2105b76402011f786d9576c7').then(console.log))

to run transaction:
MetaCoin.deployed().then(m=>m.sendCoin('0xed8abc31bc3b8d9d2105b76402011f786d9576c7', 1).then(console.log))
