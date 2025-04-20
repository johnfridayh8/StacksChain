;; Title: StacksChain
;; Summary: 
;; A decentralized research funding platform built on Stacks Layer 2, enabling transparent 
;; Bitcoin-backed research grants with milestone-based funding and peer review.
;;
;; Description:
;; This smart contract implements a decentralized autonomous organization (DAO) for funding
;; scientific and technical research. It allows researchers to submit proposals, receive 
;; community funding in STX tokens, and deliver results through milestone-based achievements.
;; The system incorporates reputation scoring, peer review mechanisms, and escrow-based fund
;; management to ensure accountability and quality in the research ecosystem.
;;
;; Bitcoin compliance is ensured through the use of Stacks Layer 2 security and
;; transparent on-chain fund management, with all transactions anchored to Bitcoin.

;; Define constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_NOT_AUTHORIZED (err u100))
(define-constant ERR_INVALID_AMOUNT (err u101))
(define-constant ERR_PROPOSAL_NOT_FOUND (err u102))
(define-constant ERR_INSUFFICIENT_FUNDS (err u103))
(define-constant ERR_INVALID_STATUS (err u104))
(define-constant ERR_DEADLINE_PASSED (err u105))
(define-constant ERR_INVALID_REVIEW (err u106))
(define-constant ERR_ALREADY_REVIEWED (err u107))
(define-constant ERR_NOT_ENOUGH_REVIEWS (err u108))
(define-constant ERR_INVALID_DEADLINE (err u109))
(define-constant ERR_INVALID_MILESTONES (err u110))
(define-constant ERR_INSUFFICIENT_REPUTATION (err u111))
(define-constant ERR_ACTIVE_PROPOSAL_EXISTS (err u112))
(define-constant ERR_EVENT_EMISSION_FAILED (err u113))
(define-constant ERR_INVALID_MILESTONE_INDEX (err u114))
(define-constant ERR_MAP_UPDATE_FAILED (err u115))
(define-constant ERR_INVALID_MILESTONE (err u116))
(define-constant MAX_EVENT_LENGTH u500)
(define-constant MAX_DESCRIPTION_LENGTH u500)

;; Define data maps
(define-map Proposals
  { proposal-id: uint }
  {
    researcher: principal,
    title: (string-ascii 100),
    description: (string-utf8 1000),
    requested-amount: uint,
    status: (string-ascii 20),
    funded-amount: uint,
    milestones: (list 5 (string-ascii 100)),
    deadline: uint,
    review-count: uint,
    average-rating: uint,
    escrow-amount: uint
  }
)

(define-map ResearcherBalance principal uint)
(define-map ResearcherReputation principal uint)
(define-map Reviews { proposal-id: uint, reviewer: principal } { rating: uint, comment: (string-utf8 500) })
(define-map Votes { proposal-id: uint, voter: principal } uint)
(define-map ActiveResearcherProposals principal uint)

(define-map Events 
  { event-id: uint } 
  { 
    event-type: (string-ascii 20),
    proposal-id: uint,
    data: (string-utf8 500)
  }
)

;; Define variables
(define-data-var proposal-count uint u0)
(define-data-var total-funds uint u0)
(define-data-var min-reputation-for-proposal uint u10)
(define-data-var last-event-id uint u0)

;; Helper functions

;; Updates a proposal with new data
(define-private (update-proposal (proposal-id uint) (proposal {researcher: principal, title: (string-ascii 100), 
    description: (string-utf8 1000), requested-amount: uint, status: (string-ascii 20), funded-amount: uint, 
    milestones: (list 5 (string-ascii 100)), deadline: uint, review-count: uint, average-rating: uint, escrow-amount: uint}))
  (if (map-set Proposals { proposal-id: proposal-id } proposal)
    (ok true)
    (err ERR_MAP_UPDATE_FAILED)))

;; Updates a specific milestone in a milestone list
(define-private (update-milestone-at-index 
  (milestones (list 5 (string-ascii 100))) 
  (index uint) 
  (new-milestone (string-ascii 100))
)
  (let
    ((len (len milestones)))
    (asserts! (< index len) ERR_INVALID_MILESTONE_INDEX)
    (ok (get result (fold update-milestone-fold 
      milestones
      {
        current-index: u0,
        target-index: index,
        new-milestone: new-milestone,
        result: (list)
      }
    )))
  )
)

;; Helper function for the milestone update process
(define-private (update-milestone-fold
  (milestone (string-ascii 100))
  (state { 
    current-index: uint, 
    target-index: uint, 
    new-milestone: (string-ascii 100), 
    result: (list 5 (string-ascii 100))
  })
)
  (let
    (
      (updated-result (unwrap-panic (as-max-len? 
        (append (get result state) 
          (if (is-eq (get current-index state) (get target-index state))
              (get new-milestone state)
              milestone))
        u5)))
    )
    (merge state { 
      current-index: (+ (get current-index state) u1),
      result: updated-result
    })
  )
)

;; Emits an event to the blockchain for tracking important actions
(define-private (emit-event (event-type (string-ascii 20)) (proposal-id uint) (data (string-utf8 500)))
  (let
    ((event-id (+ (var-get last-event-id) u1))
     (truncated-data (unwrap-panic (as-max-len? data u500))))
    (if (map-set Events
         { event-id: event-id }
         {
           event-type: event-type,
           proposal-id: proposal-id,
           data: truncated-data
         })
      (begin
        (var-set last-event-id event-id)
        (ok event-id))
      (err ERR_EVENT_EMISSION_FAILED))))