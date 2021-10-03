
import { firestore } from 'firebase-admin'
import Stripe from 'stripe'
import { FirestoreKey } from '../../constants'
import { CreditCardCreationInfo } from './types'
import { CreditCardSchema } from './schema'


export interface PaymentDAOInterface {

    /**
     * Creates a customer in stripe and returns the customerID.
     */
    createCustomer(): Promise<string>


    createCreditCard(uid: string, customerID: string, cardInfo: CreditCardCreationInfo): Promise<void>

    deleteCreditCard(creditCardID: string): Promise<void>;


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

    async createCreditCard(uid: string, customerID: string, cardInfo: CreditCardCreationInfo): Promise<void> {
        await this.api.paymentMethods.create({
            customer: customerID,
            type: 'card',
            card: {
                number: cardInfo.cardNumber,
                exp_month: cardInfo.exp_month,
                exp_year: cardInfo.exp_year,
                cvc: cardInfo.cvc
            }
        }).then(res => {
            const data: CreditCardSchema = {
                holderName: cardInfo.cardHolderName,
                expDate: `${cardInfo.exp_month}/${cardInfo.exp_year}`,
                last4: cardInfo.cardNumber.substring(cardInfo.cardNumber.length - 4)
            }
            return this.db.collection(FirestoreKey.users).doc(uid).collection(FirestoreKey.creditCards).doc().create(data)
        })
    }

    updateCreditCard() {
        //Update default
    }

    async deleteCreditCard(creditCardID: string): Promise<void> {
        await this.api.paymentMethods.detach(creditCardID)
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