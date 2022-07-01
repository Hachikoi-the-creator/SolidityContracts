# Table of contents
- [Table of contents](#table-of-contents)
  - [Docs](#docs)
- [Process protocol 2](#process-protocol-2)
  - [Weird in-console testin](#weird-in-console-testin)
- [Process protocol 3](#process-protocol-3)



## Docs
- Pragamatism: is a way of dealing with problems or situations that focuses on practical approaches and solutions—ones that will work in practice, as opposed to being ideal in theory. The word pragmatism is often contrasted with the word idealism, which means based on or having high principles or ideals.

<!------------------------------------->
<!--------------PROTOCOL 2------------->
<!------------------------------------->

# Process protocol 2
## Weird in-console testin
s- npx hardhat console --network optimism
 
**create and deploy the contract in optimism kovan**
```js
factory = ethers.getContractFactory("Casino")
contract = await factory
casino = await contract.deploy()
```

**variables needed for sol 2 (hashA & B)**
```js
// copied those from casinoTest.js
// copy & paste 1 by 1, or weird things happen
const valA = ethers.utils.keccak256(0xBAD060A7);
const hashA = ethers.utils.keccak256(valA);
const valBwin = ethers.utils.keccak256(0x600D60A7);
```

**Betting process**
- NEEDS TO BET THE SAME VALUE 

```js
// A proposes a bet
tx1 = await casino.proposeBet(hashA, {value: 5e9})
// B accepts the bet
tx2 = await casino.acceptBet(hashA, valBwin, {value: 5e9})
// get receipt ??
recept = await tx2.wait()

// settle the bet 
//calculates hash on it's own//
tx3 = await casino.reveal(valA)
```

<!------------------------------------->
<!--------------PROTOCOL 3------------->
<!------------------------------------->


# Process protocol 3
s- npx hardhat console --network optimism
- Overall just a couple of changes but since both nums were hashed the transaction to accept the bet took considerably more time!
 
**create and deploy the contract in optimism kovan**
```js
factory = ethers.getContractFactory("Casino")
contract = await factory
casino = await contract.deploy()
```

**variables needed for sol 2 (hashA & B)**
```js
// copied those from casinoTest.js
// copy & paste 1 by 1, or weird things happen
const valA = ethers.utils.keccak256(0xBAD060A7);
const hashA = ethers.utils.keccak256(valA);
const valB = ethers.utils.keccak256(0x600D60A7);
const hashB = ethers.utils.keccak256(valB);
```

**Betting process**
```js
// A proposes a bet
tx1 = await casino.proposeBet(hashB, {value: 3e9})
// B accepts the bet
tx2 = await casino.acceptBet(hashB, hashB, {value: 3e9})
// get receipt ??
recept = await tx2.wait()

// settle the bet 
//calculates hash on it's own//
tx3 = await casino.reveal(valB)
```
