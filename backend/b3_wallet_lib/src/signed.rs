use ic_cdk::api::time as ic_timestamp;
use ic_cdk::export::{candid::CandidType, serde::Deserialize};

#[derive(CandidType, Clone, Deserialize)]
pub struct SignedTransaction {
    pub data: Vec<u8>,
    pub timestamp: u64,
}

impl Default for SignedTransaction {
    fn default() -> Self {
        SignedTransaction {
            data: Vec::new(),
            timestamp: 0,
        }
    }
}

impl SignedTransaction {
    pub fn new(data: Vec<u8>) -> Self {
        SignedTransaction {
            data,
            timestamp: ic_timestamp(),
        }
    }
}