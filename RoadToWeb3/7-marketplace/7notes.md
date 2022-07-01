# Table of contents
- [Table of contents](#table-of-contents)
  - [Deployments](#deployments)
  - [Extra challenges](#extra-challenges)
  - [Tutorial extra thingys to do](#tutorial-extra-thingys-to-do)
  - [Force network change](#force-network-change)


- (adx) - 0x9f83523C25aC79Be71ea16F303c38FA7b792A5e8
- (github) - https://github.com/Hachikoi-the-creator/NFT-Marketplace
- (vercel) - https://nft-marketplace-kappa-blush.vercel.app/
## Deployments
- (goerly) - 0x82f435d10c1E099eE988eB8774F70DF8e196A1C2

## Extra challenges
1. Change the `updateListingPrice()` to only be able to be called by the current owner of the NFT (may need to do something whit the logic behind `ListedToken`, prob not)
2. Inside `getAllNFTs()` add an if inside the or loop to filter out all the imtes that ,are not listed for sale (the owner doesn't want to sell them yeet)
3. In `getAllNFTs()` find a way to remove the `storage` keyword, to make it more gas efficient
4. Big change in logic so the array `ListedToken` starts at 0 index (bothers me a lot lmao)
5. `getMyNFTs()` regardless of not being able to cut the loop down, I want to make a little helper to make the **if** less verbose
6. `getMyNFTs()` Also fin a way to only use a sinlge **uint**
7. `executeSale()` is supposed to complete the sell of an NFT, thus  should chnage it to compare the market fee + the NFT price itself == msg.value
8. `executeSale()` change transfer method (to the one used in the last week, weird sintax, returns bool)
9. `executeSale()` change the state of liset to false, since we don't want anybody to just buy an nft that I have, withou me wanting to sell it. **May even need a helper function to handle the payment logic**
10. Change naming of `*Debugging functions`

## Tutorial extra thingys to do    
- Use Alchemy's getNFTs and getNFTsForCollection endpoints to fetch NFTs for the marketplace and profile page
- Add functionality to let users list pre-existing NFTs to the marketplace
- Adding Royalties such that the original NFT creator gets 10% of the proceeds every time that NFT gets sold
- (Basic contract) - 0x517427e91f891eB534843f75Ba0a39b23706f2FB

## Force network change
```jsx
async const connectWebsite = () {
 
  const chainId = await window.ethereum.request({ method: 'eth_chainId' });
  if (chainId !== '0x5') {
    console.log('Incorrect network! Switch your metamask network to Rinkeby, sending request to change');
    await window.ethereum.request({
      method: 'wallet_switchEthereumChain',
      params: [{ chainId: '0x5' }],
    });
  }
  
  await window.ethereum.request({ method: 'eth_requestAccounts' })
    .then(() => {
      updateButton();
      console.log("here");
      getAddress();
      window.location.replace(location.pathname);
    });
};

// useEffect fixed 2nd loading
useEffect(() => {
    const val = window.ethereum.isConnected();
    if (val) {
      console.log("connecting wallet");
      getAddress();
      toggleConnect(val);
      updateButton();
    }

    window.ethereum.on('accountsChanged', (accounts) => {
      // does f5 if the chain changes
      window.location.replace(location.pathname);
    });
  });
```