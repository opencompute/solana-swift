## 3.0.0

- Change iconUrl of some tokens
- Fix decoding for ConfirmedTransaction
- Add support additional params for socket
- Conform PreparedTransaction to Equatable
- Rename Account to KeyPair and deprecated Account
- Public some structs
- Fix decimal for USDC from 8 to 6
- Add empty init for KeyPair
- Add test for SendTransaction
- Add support Commitment in getTokenWallets
- Add support for VersionedTransaction

## 2.5.3

- Add rpc method getRecentPerformanceSamples
- Change tokens repository endpoint

## 2.5.2

- Add convenience variables for common tokens (ETH, USDT)
- Make signing in method prepare transaction optional if signers is not provided

## 2.5.1

- Add supply property for struct Wallet

## 2.5.0

- Add usdc to TokenList
- Add slot info to TransactionStatus
- Add option skipPreflight to RequestModels

## 2.4.0

- Replacing LoggerSwift with abstraction

## 2.3.0

- Added support for socket encoding response

## 2.2.2

- Update coingeko id for SOL and renBTC

## 2.2.1

- Publish init SendingTransaction with Signature
- Fix batch loading with zero and one element

## 2.2.0

- Improve batch loading with same request type

## 2.1.3

- Fix message deserialization
- Add partial sign

## 2.1.0

- Fix `prepareForSendingNativeSOL`
- Enable testnet only on debug

## 2.0.1

- Update documentation
- Update `Task_retrying`

## 2.0.0

- Migrate to swift concurrency

## 1.0.0

- Release library
