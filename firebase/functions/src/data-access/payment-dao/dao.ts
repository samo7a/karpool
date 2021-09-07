
import Stripe from 'stripe'
import stripe from 'stripe'


export interface PaymentDAOInterface {

    /**
     * Creates a customer in stripe and returns the customerID.
     */
    createCustomer(): Promise<string>
}

export class PaymentDAO implements PaymentDAOInterface {

    private api: Stripe

    constructor(stripePublicKey: string, stripePrivateKey: string) {
        this.api = new stripe(stripePrivateKey, { apiVersion: '2020-08-27' })
    }

    createCustomer(): Promise<string> {
        return this.api.customers.create().then(res => {
            return res.id
        })
    }



}