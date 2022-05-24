# Table of contents
- [Table of contents](#table-of-contents)
  - [Constant vs Inmutable](#constant-vs-inmutable)
  - [Types of variables (scope)](#types-of-variables-scope)
  - [ETH base values & exp](#eth-base-values--exp)
  - [if else & ternary JS](#if-else--ternary-js)
- [while (break & continue) valid!](#while-break--continue-valid)
  - [Array declaration](#array-declaration)
- [code](#code)

## Constant vs Inmutable

- Constanst cannot be modified in any way, need to be declared whit an initial value

```c#
string public constant MY_STR = "This can save gas cost!"
```

- Inmutable values, can have their value intialized inside the constructor, but canot be changed later on

```c#
address public immutable MY_ADDRESS;

constructor(uint _myUint) {
    MY_ADDRESS = msg.sender;
}
```

## Types of variables (scope)
- Global: Are variables that are provided by the EVM, pretty much like BS4 language (msg.sender = the address of the user calling the contract)
- State: Variables declared inside the Contract scope
- Local: Variables that only exist inside a function call


## ETH base values & exp
- 1 ETH == 10^18 wei
- 1 pwei (termed finney after Hal Finney) equals 10^-3 ETH.
- 1 twei (termed szabo after Nick Szabo) equals 10^-6 ETH. 
- 1 mwei (termed lovelace after Ada Lovelace) is equal to 10^-12 ETH. 
- 1 kwei (termed babbage after Charles Babbage) is equal to 10^-15 ETH. 
- 1 wei (named for Wei Dai, a “godfather” of the crypto movement) == 1^-18 ETH.


## if else & ternary JS
Normal daily life if, if else, but...
Support for JS-like ternary operator!

```c#
int public number = myBoolean ? 90 : 69
```

# while (break & continue) valid!


## Array declaration 
**(methods same as in JS)**
```c#

```

# code
```c#```
```c#```
```c#```