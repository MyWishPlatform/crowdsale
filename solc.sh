#!/usr/bin/env bash
solc --bin --abi --gas --optimize -o target --overwrite ./contracts/MyWishCrowdsale.sol
