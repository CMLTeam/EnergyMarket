Truffle warts:
==============

```
$ truffle console
truffle(development)> HelloWorld.deployed().then(hw=>hw.balance.call().then(v=>console.log(v)))
{ [String: '1000'] s: 1, e: 3, c: [ 1000 ] }
```
