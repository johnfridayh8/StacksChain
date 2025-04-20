# StacksChain

**StacksChain** is a decentralized research funding platform built on the **Stacks Layer 2** blockchain, designed to bring transparency, accountability, and community governance to the process of funding scientific and technical research. All funds and activity are anchored to the Bitcoin blockchain via Stacks' secure smart contracts.

## Overview

StacksChain introduces a Bitcoin-backed decentralized autonomous organization (DAO) that allows:

- **Researchers** to submit research proposals and milestones.
- **Funders** to contribute STX tokens to vetted research projects.
- **Community Reviewers** to evaluate and rate the quality of research outputs.
- **Contract Owners** to approve proposals and release funds based on peer-reviewed milestones.

By integrating **escrow-based fund management**, **peer review**, and **reputation scoring**, StacksChain builds a trust-minimized ecosystem for next-generation research funding.

## Key Features

- **Bitcoin-anchored Funding:** All fund transfers and events are transparently recorded and secured via Stacks Layer 2 and ultimately anchored to Bitcoin.
- **Milestone-Based Grants:** Projects are broken into milestones, ensuring incremental funding and validation of results.
- **Peer Reviews:** Proposals are reviewed and rated by community members to maintain accountability and quality.
- **Reputation System:** Researchers gain or lose reputation based on their performance, affecting future proposal eligibility.
- **Event Logging:** Every major contract action is tracked on-chain with structured events.

## Contract Architecture

### Maps

| Name | Description |
|------|-------------|
| `Proposals` | Stores research proposals with metadata and funding details |
| `ResearcherBalance` | Tracks STX balances assigned to each researcher |
| `ResearcherReputation` | Maintains researcher reputation scores |
| `Reviews` | Stores community reviews and ratings of proposals |
| `Votes` | Placeholder for potential governance features |
| `ActiveResearcherProposals` | Ensures one active proposal per researcher |
| `Events` | On-chain logs for traceability of key contract events |

### Variables

- `proposal-count`: Tracks number of submitted proposals
- `total-funds`: Total funds raised through the contract
- `min-reputation-for-proposal`: Minimum required reputation to submit a proposal
- `last-event-id`: Sequential ID for event tracking

## User Roles & Interactions

### Researchers
- Submit proposals with title, description, requested STX amount, milestones, and deadline.
- Gain reputation upon successful completion.

### Reviewers
- Submit ratings and comments on approved proposals.
- Influence fund release decisions via peer evaluation.

### Funders
- Fund approved proposals with STX tokens.
- Contributions are stored in escrow until milestone reviews are verified.

### Contract Owner
- Approves or rejects pending proposals.
- Releases funds post successful milestone reviews.
- Sets minimum reputation thresholds.

## Lifecycle of a Proposal

1. **Submission**: Researcher submits a proposal (requires minimum reputation).
2. **Approval**: Contract owner reviews and approves proposal.
3. **Funding**: Community contributes STX to the approved proposal.
4. **Review**: Reviewers evaluate the output after milestones are achieved.
5. **Fund Release**: Upon sufficient positive reviews, the contract owner releases funds.
6. **Reputation Gain**: Researcher gains reputation if successful.

## Key Functions

| Function | Purpose |
|---------|---------|
| `submit-proposal` | Submit a new research proposal |
| `approve-proposal` | Approve a pending proposal (owner only) |
| `fund-proposal` | Fund an approved proposal with STX |
| `submit-review` | Submit a review and rating for a proposal |
| `release-funds` | Release escrow funds after successful review (owner only) |
| `set-min-reputation` | Set reputation threshold to submit proposals (owner only) |


## Security & Validations

- Proposal integrity checks (lengths, deadlines, status)
- Role-based access control for sensitive operations
- Double-review prevention and rating bounds
- Escrow logic with verification of review count and average score
- Reputation checks to prevent spam and maintain research quality

## Deployment Considerations

- Designed to run on **Stacks blockchain** (Clarity language)
- Deploy with a principal as `CONTRACT_OWNER` for administration
- Recommended to integrate with a front-end for easier proposal discovery, funding, and reviews

## Future Improvements

- DAO-based governance for proposal approval and fund release
- Milestone-specific fund unlocking
- Reviewer incentives and dispute resolution system
- Integration with off-chain data providers and reputation oracles
