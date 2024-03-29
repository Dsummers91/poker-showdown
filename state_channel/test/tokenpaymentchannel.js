const TokenPaymentChannel = artifacts.require('./TokenPaymentChannel.sol');
const ERC20 = artifacts.require('./ERC20.sol');


contract('TokenPaymentChannel', async (accounts) => {
  let token, contract;
  let dappOwner = accounts[9];

  before(async () => {
    contract = await TokenPaymentChannel.new({ from: dappOwner });
    token = await ERC20.new(100e18, "Token", 18, "TKN", contract.address);
    await token.approve(contract.address, 100e18);
  })

  it('should be able to create a channel', async () => {
    let tokenAmount = 5e18;

    let channelHash = await contract.getChannelHash(token.address, tokenAmount, accounts[0]);

    let signedChannelHash = web3.eth.sign(dappOwner, channelHash);
    let r = signedChannelHash.substr(0,66) 
    let s = "0x" + signedChannelHash.substr(66,64);
    let v = +signedChannelHash.substr(130)+27;

    await contract.openChannel(token.address, tokenAmount, v, r, s);

    let channel = await contract.channel(channelHash);
    assert.equal(channel[0], token.address);
    assert.deepEqual(channel[1], web3.toBigNumber(tokenAmount));
    assert.equal(channel[2], 1);
    assert.equal(channel[3], accounts[0], 'participant is not first account');

    let contractTokenBalance = await token.balanceOf(contract.address);
    assert.deepEqual(contractTokenBalance, web3.toBigNumber(tokenAmount));
  });


  it('should be able to close a channel without any transaction within it', async() => {
    let tokenAmount = 5e18;
    let channelHash = await contract.getChannelHash(token.address, tokenAmount, accounts[0]);


    let signedChannelHash = web3.eth.sign(dappOwner, channelHash);
    let r = signedChannelHash.substr(0,66) 
    let s = "0x" + signedChannelHash.substr(66,64);
    let v = +signedChannelHash.substr(130)+27;


    let participantTokenBalance = await token.balanceOf(accounts[0]);
    assert.deepEqual(participantTokenBalance, web3.toBigNumber(95e18));

    let contractTokenBalance = await token.balanceOf(contract.address);
    assert.deepEqual(contractTokenBalance, web3.toBigNumber(5e18));

    await contract.closeChannel(channelHash, 5e18, channelHash, v, r, s);
    participantTokenBalance = await token.balanceOf(accounts[0]);
    assert.deepEqual(participantTokenBalance, web3.toBigNumber(100e18));

    contractTokenBalance = await token.balanceOf(contract.address);
    assert.deepEqual(contractTokenBalance, web3.toBigNumber(0));


    let channel = await contract.channel(channelHash);
    assert.equal(channel[2], 3, 'Channel isn\'t closed');
  })

  it('should be able to close a channel with transaction within it', async() => {
    let tokenAmount = 10e18;
    let channelHash = await contract.getChannelHash(token.address, tokenAmount, accounts[0]);

    let signedChannelHash = web3.eth.sign(dappOwner, channelHash);
    let r = signedChannelHash.substr(0,66) 
    let s = "0x" + signedChannelHash.substr(66,64);
    let v = +signedChannelHash.substr(130)+27;

    await contract.openChannel(token.address, tokenAmount, v, r, s);

    let participantTokenBalance = await token.balanceOf(accounts[0]);
    assert.deepEqual(participantTokenBalance, web3.toBigNumber(90e18));

    let contractTokenBalance = await token.balanceOf(contract.address);
    assert.deepEqual(contractTokenBalance, web3.toBigNumber(tokenAmount));

    
    let channelCloseHash = await contract.getChannelCloseHash(channelHash, 9e18);
    signedChannelHash = web3.eth.sign(dappOwner, channelCloseHash);
    r = signedChannelHash.substr(0,66) 
    s = "0x" + signedChannelHash.substr(66,64);
    v = +signedChannelHash.substr(130)+27;
    
    await contract.closeChannel(channelHash, 9e18, channelCloseHash, v, r, s);
    participantTokenBalance = await token.balanceOf(accounts[0]);
    assert.deepEqual(participantTokenBalance, web3.toBigNumber(99e18));

    let dappOwnerBalance = await token.balanceOf(dappOwner);
    assert.deepEqual(dappOwnerBalance, web3.toBigNumber(1e18));


    let channel = await contract.channel(channelHash);
    assert.equal(channel[2], 3, 'Channel isn\'t closed');
  })
});
