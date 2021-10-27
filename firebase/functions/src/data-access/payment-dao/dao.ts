
import { firestore } from 'firebase-admin'
import Stripe from 'stripe'
import { FirestoreKey } from '../../constants'
import { CreditCardSchema } from './schema'
import { HttpsError } from 'firebase-functions/lib/providers/https'
// import { AccountSubtype, CountryCode, LinkTokenCreateRequest, PlaidApi } from 'plaid'

export interface PaymentDAOInterface {

    /**
     * Creates a customer in stripe and returns the customerID.
     */
    createCustomer(): Promise<string>

    deleteCustomer(id: string): Promise<void>


    /**
     * Creates a card object in stripe and in Firestore given a token generated on the client.
     * @param uid The user's id.
     * @param customerID The user's stripe customer id.
     * @param cardToken The one-time use card token.
     */
    createCreditCard(uid: string, customerID: string, cardToken: string): Promise<void>


    /**
     * Gets all credit cards for a specific user.
     * @param uid The user's id.
     */
    getCreditCards(uid: string): Promise<CreditCardSchema[]>

    /**
     * Detaches the card from a customer and deletes its information from Firestore.
     * @param creditCardID The credit card's Stripe id.
     */
    deleteCreditCard(creditCardID: string): Promise<void>


    setBankAccount(uid: string, customerID: string, accountNum: string, routingNum: string): Promise<any>


}

export class PaymentDAO implements PaymentDAOInterface {

    private api: Stripe

    private db: firestore.Firestore

    // private plaid: PlaidApi

    constructor(stripePublicKey: string, stripePrivateKey: string, db: firestore.Firestore) {
        this.api = new Stripe(stripePrivateKey, { apiVersion: '2020-08-27' })
        this.db = db
    }

    createCustomer(): Promise<string> {
        return this.api.customers.create().then(res => {
            return res.id
        })
    }

    async deleteCustomer(id: string): Promise<void> {
        await this.api.customers.del(id)
    }

    async createCreditCard(uid: string, customerID: string, cardToken: string): Promise<void> {
        const method = await this.api.paymentMethods.attach(cardToken, { customer: customerID })
        const card = method.card
        if (card !== undefined) {
            const data: CreditCardSchema = {
                cardHolder: method.billing_details.name ?? 'Unknown',
                last4: card.last4,
                expMonth: `${card.exp_month}`,
                expYear: `${card.exp_year}`,
                isDefault: false,
                brand: card.brand,
                id: method.id,
                userID: uid
            }
            const ref = this.db.collection(FirestoreKey.creditCards).doc(method.id)
            await ref.create(data)
        } else {
            throw new HttpsError('failed-precondition', `Expected card object.`)
        }
    }

    getCreditCards(uid: string): Promise<CreditCardSchema[]> {
        return this.db.collection(FirestoreKey.creditCards).where('userID', '==', uid).get().then(snap => {
            return snap.docs.filter(doc => doc.exists).map(doc => doc.data()) as CreditCardSchema[]
        })
    }

    async deleteCreditCard(creditCardID: string): Promise<void> {
        await this.api.paymentMethods.detach(creditCardID).then(res => {
            return this.db.collection(FirestoreKey.creditCards).doc(creditCardID).delete()
        })
    }


    setBankAccount(uid: string, customerID: string, accountNum: string, routingNum: string): Promise<any> {
        return this.api.tokens.create({
            bank_account: {
                country: 'US',
                currency: 'usd',
                account_holder_name: 'Jenny Rosen',
                account_holder_type: 'individual',
                routing_number: routingNum,
                account_number: accountNum
            }
        }).then(res => {
            return this.api.customers.createSource(customerID, { source: res.id })
        })
        // //Create token client side and send to the server for PCI compliance.
        // //Create bank account object attached to the customer, server side.
        // return this.api.customers.createSource(customerID, { source: accountToken }).then(res => {
        //     console.log(res.object, res) //TODO: Update user document.
        // })
    }


    async createCharge(amount: number, cardID: string, description: string): Promise<void> {
        await this.api.charges.create({
            amount: amount,
            source: cardID,
            currency: 'usd',
            description: description
        })
        //Payment method id 
        //TRIP ID
        //Amount
    }


    async createPayout(amount: number): Promise<void> {
        await this.api.payouts.create({
            source_type: 'bank_account',
            amount: amount,
            currency: 'usd'

        })
    }

    // async createBankAccountLink(userID: string): Promise<string> {
    //     const request: LinkTokenCreateRequest = {
    //         user: {
    //             client_user_id: userID,
    //         },
    //         client_name: 'Karpool',
    //         products: [],
    //         country_codes: [CountryCode.Us],
    //         language: 'en',
    //         webhook: 'https://sample-web-hook.com',
    //         account_filters: {
    //             depository: {
    //                 account_subtypes: [AccountSubtype.Checking, AccountSubtype.Savings]
    //             },
    //         },
    //     };
    //     return this.plaid.linkTokenCreate(request).then(res => res.data.link_token)
    // }






}