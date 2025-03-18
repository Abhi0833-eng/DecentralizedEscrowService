module MyModule::EscrowService {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    struct Escrow has key, store {
        buyer: address,
        seller: address,
        amount: u64,
    }

    /// Function to initiate an escrow transaction
    public fun initiate_escrow(buyer: &signer, seller: address, amount: u64) {
        let escrow = Escrow {
            buyer: signer::address_of(buyer),
            seller,
            amount,
        };
        move_to(buyer, escrow);
    }

    /// Function to release funds from escrow to the seller
    public fun release_funds(buyer: &signer) acquires Escrow {
        let escrow = move_from<Escrow>(signer::address_of(buyer));
        let payment = coin::withdraw<AptosCoin>(buyer, escrow.amount);
        coin::deposit<AptosCoin>(escrow.seller, payment);
    }
}
