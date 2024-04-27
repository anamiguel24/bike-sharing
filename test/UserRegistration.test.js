//const artifacts = require('truffle/build/webpack');
//const { expect } = require('chai');
//import chai from 'chai';
//import { expect } from 'chai';
const UserRegistration = artifacts.require("UserRegistration");

contract("UserRegistration", (accounts) => {
  let userRegistrationInstance;

  beforeEach(async () => {
    userRegistrationInstance = await UserRegistration.deployed();
  });

  it("registers a new user", async () => {
    const name = "John Doe";
    const walletAddress = accounts[0];

    await userRegistrationInstance.registerRenter(walletAddress, name, { from: accounts[0] });

    const { 0: registeredName, 1: canRent, 2: balance, 3: isRegistered } = await userRegistrationInstance.getRenterDetails(walletAddress);
    expect(registeredName).to.equal(name, "User name is incorrect");
    expect(isRegistered).to.equal(true, "User is not registered");
  });

  it("disallows registering an existing user", async () => {
    const name = "Jane Doe";
    const walletAddress = accounts[1];

    await userRegistrationInstance.registerRenter(walletAddress, name, { from: accounts[1] });

    try {
      await userRegistrationInstance.registerRenter(walletAddress, name, { from: accounts[1] });
      assert.fail("Registering an existing user should fail");
    } catch (error) {
      expect(error.message).to.include("User already exists.", "Error message is incorrect");
    }
  });

  it("returns user details", async () => {
    const name = "Jim Smith";
    const walletAddress = accounts[2];
    //const initialBalance = 100;

    //await userRegistrationInstance.registerRenter(walletAddress, name, { value: initialBalance, from: accounts[2] });
    await userRegistrationInstance.registerRenter(walletAddress, name, { from: accounts[2] });

    const { 0: registeredName, 1:canRent, 2:balance, 3:isRegistered } = await userRegistrationInstance.getRenterDetails(walletAddress);

    //console.log(`balance: ${balance}`);
    //console.log(`initialBalance: ${initialBalance}`);
    expect(registeredName).to.equal(name, "User name is incorrect");
    expect(canRent).to.equal(true, "User can't rent");
    expect(balance.toNumber()).to.equal(0, "User balance is incorrect");
    //expect(balance).to.equal(initialBalance, "User balance is incorrect");
    expect(isRegistered).to.equal(true, "User is not registered");
  });
});