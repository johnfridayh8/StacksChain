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