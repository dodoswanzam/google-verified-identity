;; google-verified-identity.clar
{ user: principal }
{ google-hash: (buff 32) })


;; user -> google-hash (verified)
(define-map verified
{ user: principal }
{ google-hash: (buff 32), token-id: uint })


(define-constant err-unauthorized (err u100))
(define-constant err-already-verified (err u101))
(define-constant err-no-pending (err u102))
(define-constant err-already-pending (err u103))


(define-read-only (get-oracle)
(ok (var-get oracle)))


(define-public (set-oracle (new-oracle principal))
(begin
(if (is-eq tx-sender (var-get oracle))
(begin (var-set oracle new-oracle) (ok true))
err-unauthorized)))


(define-read-only (is-verified (user principal))
(ok (is-some (map-get? verified { user: user }))))


(define-read-only (get-verified (user principal))
(match (map-get? verified { user: user })
verified-data (ok verified-data)
(err u404)))


(define-public (request-verify (google-hash (buff 32)))
(begin
(if (is-some (map-get? verified { user: tx-sender }))
err-already-verified
(if (is-some (map-get? pending-claims { user: tx-sender }))
err-already-pending
(begin
(map-set pending-claims { user: tx-sender } { google-hash: google-hash })
(ok true))))))


(define-public (oracle-approve (user principal))
(begin
(if (is-eq tx-sender (var-get oracle))
(match (map-get? pending-claims { user: user })
pending
(let
(
(token-id (var-get next-id))
)
(begin
(try! (nft-mint? gvid token-id user))
(map-set verified { user: user }
{ google-hash: (get google-hash pending), token-id: token-id })
(map-delete pending-claims { user: user })
(var-set next-id (+ token-id u1))
(ok token-id)))
err-no-pending)
err-unauthorized)))


;; Optional: make identity NFT non-transferable by overriding transfer to always fail
(define-public (transfer (token-id uint) (sender principal) (recipient principal))
(err u999))