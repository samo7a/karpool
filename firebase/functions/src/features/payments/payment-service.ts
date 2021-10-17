

export class PaymentService {


    chargeRider(id: string, amount: number): Promise<void> {
        return Promise.reject(new Error('Unimplmented'))
    }

    makeDeposits(): Promise<void> {
        return Promise.reject(new Error('Unimplmented'))
    }
}