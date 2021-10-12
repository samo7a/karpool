
import { firestore } from 'firebase-admin'
import Stripe from 'stripe'
import { FirestoreKey } from '../../constants'
import { CreditCardSchema } from './schema'
import { HttpsError } from 'firebase-functions/lib/providers/https'

export interface PaymentDAOInterface {

    /**
     * Creates a customer in stripe and returns the customerID.
     */
    createCustomer(): Promise<string>


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


    createBankAccount(uid: string, customerID: string, email: string,): Promise<void>

    deleteBankAccount(): Promise<void>

    updateBankAccount(): Promise<void>

    verifyBankAccount(): Promise<void>


}

export class PaymentDAO implements PaymentDAOInterface {

    private api: Stripe

    private db: firestore.Firestore

    constructor(stripePublicKey: string, stripePrivateKey: string, db: firestore.Firestore) {
        this.api = new Stripe(stripePrivateKey, { apiVersion: '2020-08-27' })
        this.db = db
    }

    createCustomer(): Promise<string> {
        return this.api.customers.create().then(res => {
            return res.id
        })
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


    createBankAccount(uid: string, customerID: string, email: string,): Promise<void> {
        return Promise.reject()
        //Create token client side and send to the server for PCI compliance.
        //Create bank account object attached to the customer, server side.


        // this.api.customers.createSource(customerID, { source: '' })
        // return this.api.sources.create({
        //     type: 'ach_credit_transfer',
        //     currency: 'USD',
        //     customer: customerID,
        //     owner: {
        //         email: email
        //     }
        // })
    }

    deleteBankAccount(): Promise<void> {
        return Promise.reject()
    }

    updateBankAccount(): Promise<void> {
        return Promise.reject()
    }

    verifyBankAccount(): Promise<void> {
        return Promise.reject()
    }






}