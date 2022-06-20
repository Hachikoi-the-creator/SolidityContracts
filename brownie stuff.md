##
####
######
# DROPPED, NOT WORIKING EVEN IF IT DID IT SLOWS DOWN MY PC TOO MUCH!
######
####
##

# Installation
**Install pipx (npmx for python)**
- python -m pip install --user pipx
**Add path**
- python3 -m pipx ensurepath
**Install brownie**
- pipx install eth-brownie


## Create new project 
*Must be inside an empty dir*
- brownie init
*Force creation lol*
- brownie init --force

## Compile & stuff
- create new .sol file
- create a deploy.py in /scripts
- install ganache-cli 
  - `yarn add global ganache-cli`
  - `npm init -y`
  - `yarn ganache-cli --help` <!--Check installation-->
- Add that thing to brownie `brownie networks add Ethereum ganache host=http://localhost:8545 chainid=1337`

## Run scripts
- brownie run scripts/SCRIPT_NAME

**Show all commands**
- brownie


## Create new project from template 
*lmao*
- brownie bake
  - brownie bake token (basic ERC-20)

**Insall dependencies**
- pip install -r requirements.txt
- brownie pm <!-- no idea of how to use it lmao -->


# Linux installation
*pip is inatlle as default, chec if it pip or pip3 tho*
- pip --version //should not show a result, 
**if shows pip for python2.6**
- sudo apt-get --purge autoremove python-pip //to remove pip to phyton2

**install pipx**
- python3 -m pip install --user pipx
- python3 -m pipx ensurepath

**Install pipx**
*Reestart terminal after this one*
- python3 -m pip install --user pipx
- python3 -m pipx ensurepath

**Install brownie**
*need python venv first...*
- sudo apt-get install python3-venv
- pipx install eth-brownie


