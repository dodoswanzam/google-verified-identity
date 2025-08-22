# Google Verified Identity (Clarity Contract)

This project implements a **Clarity smart contract** that allows users to prove control of a **Google Account** on-chain through an oracle. Once verified, users receive a **non-transferable identity NFT** that serves as a verifiable credential.

---

## 📌 Features

* **Request Verification**: Users submit a SHA-256 hash of their Google identity (email + sub ID).
* **Oracle Approval**: A trusted oracle verifies the user’s Google OAuth claim and approves it on-chain.
* **Identity NFT**: A unique, non-transferable NFT (`gvid`) is minted to the user.
* **On-chain Registry**: Stores mapping of principals to their Google identity hash.
* **Security Controls**: Unauthorized or repeated requests are prevented via error codes.

---

## 📂 File

* `google-verified-identity.clar` → The Clarity contract.

---

## 🔑 Contract Functions

### **Read-only functions**

* `(get-oracle)` → Returns the current oracle address.
* `(is-verified user)` → Returns `true` if a user has been verified.
* `(get-verified user)` → Returns `{ google-hash, token-id }` for a verified user.

### **Public functions**

* `(set-oracle new-oracle)` → Allows current oracle to update the oracle principal.
* `(request-verify google-hash)` → Called by a user to request verification.
* `(oracle-approve user)` → Called by oracle to approve a pending verification and mint an identity NFT.
* `(transfer token-id sender recipient)` → Always fails (`err u999`) to ensure the NFT is **soulbound** (non-transferable).

---

## ⚠️ Error Codes

* `err u100` → Unauthorized action.
* `err u101` → User already verified.
* `err u102` → No pending verification found.
* `err u103` → Verification request already pending.
* `err u999` → NFT transfers are disabled.
* `err u404` → User not found in verified registry.

---

## 🚀 Usage Flow

1. **User** calls `request-verify` with their Google hash.
2. **Oracle** confirms Google OAuth login off-chain.
3. **Oracle** calls `oracle-approve` with the user’s principal.
4. Contract mints an **Identity NFT** (soulbound) to the user.

---

## 🛠 Development

### Local Testing

```bash
clarinet check
clarinet console
```

In console:

```clarity
(contract-call? .google-verified-identity request-verify 0x1234...)
(contract-call? .google-verified-identity oracle-approve 'ST123...)
```

### Deployment

1. Add contract to `Clarinet.toml`.
2. Deploy to Stacks testnet:

```bash
clarinet deploy
```

3. Record contract address and configure in oracle service.

---

## 🏢 Enterprise Value (Google Cloud Context)

* Proves **Google account ownership** on-chain without storing PII.
* Enables **Web3 identity gating** for Google Cloud products.
* Can be extended with voucher contracts for **API credit distribution**.

---

## 📌 Next Steps

* Connect with **oracle service** (Node/TS with Google OAuth).
* Integrate with a **voucher NFT system** for API credits.
* Deploy frontend (React + Stacks Wallet integration).

 
