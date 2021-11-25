import { HttpsError } from 'firebase-functions/lib/providers/https'
import { PaymentDAO } from "../../data-access/payment-dao/dao"
import { CreditCardSchema } from "../../data-access/payment-dao/schema"
import { UserDAOInterface } from "../../data-access/user/dao"


export class PaymentService {

    private userDAO: UserDAOInterface

    private paymentDAO: PaymentDAO

    constructor(userDAO: UserDAOInterface, paymentDAO: PaymentDAO) {
        this.userDAO = userDAO
        this.paymentDAO = paymentDAO
    }

    /**
     * 
     * @param id 
     * @param amount In cents
     * @param description 
     * @returns 
     */
    async chargeRider(id: string, amount: number, description?: string): Promise<void> {
        const [cards, user] = await Promise.all([
            this.paymentDAO.getCreditCards(id),
            this.userDAO.getAccountData(id)
        ])
        if (cards.length === 0) {
            throw new HttpsError('failed-precondition', `User ${id} does not have a credit card to charge.`)
        }
        let defaultCard: undefined | CreditCardSchema = undefined
        for (const card of cards) {
            if (card.isDefault) {
                defaultCard = card
                break
            }
        }
        if (defaultCard === undefined) {
            throw new HttpsError('failed-precondition', `User ${id} does not have a default card set.`)
        }

        return this.paymentDAO.createCharge(amount, user.stripeCustomerID, description)
    }


    makeDeposits(): Promise<void> {
        return Promise.reject(new Error('Unimplmented'))
    }
}