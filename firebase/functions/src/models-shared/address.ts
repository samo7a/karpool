
//TODO: Delete? Are we using this?
export class Address {

    /**
     * The street of the address.
     */
    street: string

    /**
     * Optional for specifying apartment building.
     */
    street2?: string

    /**
     * City the address is in.
     */
    city: string

    /**
     * State the address is in. Abbreviated state format (Uppercase).
     */
    state: string

    /**
     * Zip code the address is in.
     */
    zip: string


    constructor(
        street: string,
        city: string,
        state: string,
        zip: string,
        street2?: string //Specify last since optionals can't appear before non-optionals in the constructor.
    ) {
        this.street = street
        this.street2 = street2
        this.city = city
        this.state = state
        this.zip = zip
    }

    toString(): string {
        let firstLine = `${this.street}`
        if (this.street2) {
            firstLine += ` ${this.street2}`
        }
        const secondLine = `${this.city}, ${this.state} ${this.zip}`
        return `${firstLine}\n${secondLine}`
    }

}