
/**
 * Mimics the document snapshot class in firestore sdk so we can test fireEncode() method.
 * We can't use the makeDocumentSnapshot from the firestore test framework since were not initializing it right now.
 */
export class TestSnapShot<T> {

    _data?: any

    exists: boolean

    ref: {
        path: string
    }

    constructor(data?: any) {
        this._data = data
        this.exists = true
        this.ref = {
            path: 'some/path'
        }
    }

    data(): T | undefined {
        return this._data
    }
}

export class TestClass {

    field: Date

    nested: {
        dateField: Date
        nested: {
            dateField: Date
        }
    }

    constructor() {
        this.field = new Date()
        this.nested = {
            dateField: new Date(),
            nested: {
                dateField: new Date()
            }
        }
    }

    testMethod(): string {
        return this.field.toDateString()
    }



}
