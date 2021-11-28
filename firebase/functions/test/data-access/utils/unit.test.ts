



import { fireEncode } from '../../../src/data-access/utils/encode'
import { autoID } from '../../../src/data-access/utils/misc'
import { TestClass, TestSnapShot } from './types'
import * as admin from 'firebase-admin'
import { fireDecode } from '../../../src/data-access/utils/decode'


describe('Data Access Utilities', () => {

    describe(`#autoID()`, () => {

        test(`Creates unique ids`, () => {

            const ids = new Set()

            let trials = 100

            while (trials--) {
                const newID = autoID()
                expect(ids.has(newID)).toBe(false)
                ids.add(newID)
            }

        })

    })


    describe(`#fireEncode()`, () => {

        test(`Transforms a class into a plain object.`, () => {
            const obj = new TestClass()
            const encoded = fireEncode(obj)
            expect(Object.getPrototypeOf(obj) === TestClass.prototype).toBe(true) //Make sure original object is unchanged.
            expect(Object.getPrototypeOf(encoded) === TestClass.prototype).toBe(false)
        })

        test(`Transforms date types to firestore timestamp.`, () => {
            const obj = {
                field: new Date()
            }
            const encoded = fireEncode(obj)
            expect(encoded.field instanceof admin.firestore.Timestamp).toBe(true)

        })

        test(`Ignores null values.`, () => {
            const obj = {
                field: null
            }
            const encoded = fireEncode(obj)

            expect(encoded.field).toBe(null)

        })
    })


    describe(`#fireDecode()`, () => {


        test(`Transforms all fields and nested fields from Timestamp to Date class`, async () => {
            const expected = new Date()
            const obj = {
                field: admin.firestore.Timestamp.fromDate(expected),
                nested: {
                    dateField: admin.firestore.Timestamp.fromDate(expected),
                    nested: {
                        dateField: admin.firestore.Timestamp.fromDate(expected)
                    }
                }
            }

            const decoded = await fireDecode(TestClass, new TestSnapShot(obj) as any)

            expect(decoded.field.toISOString()).toBe(expected.toISOString())

            expect(decoded.nested.dateField.toISOString()).toBe(expected.toISOString())

            expect(decoded.nested.nested.dateField.toISOString()).toBe(expected.toISOString())

        })

        test(`Constructs instance of target class.`, async () => {
            const expected = new Date()
            const obj = {
                field: admin.firestore.Timestamp.fromDate(expected),
                nested: {
                    dateField: admin.firestore.Timestamp.fromDate(expected),
                    nested: {
                        dateField: admin.firestore.Timestamp.fromDate(expected)
                    }
                }
            }

            const decoded = await fireDecode(TestClass, new TestSnapShot(obj) as any)

            expect(decoded instanceof TestClass).toBe(true)

        })


        //This test requires class decorators which can't be used without including the test folder in the lib folder 
        // test(`Validates the classes properties`, async () => {

        //     const expected = new Date()
        //     const obj = {
        //         field: 'Some string',
        //         nested: {
        //             dateField: admin.firestore.Timestamp.fromDate(expected),
        //             nested: {
        //                 dateField: admin.firestore.Timestamp.fromDate(expected)
        //             }
        //         }
        //     }

        //     return expect(
        //         fireDecode(TestClass, new TestSnapShot(obj) as any)
        //     ).rejects.toMatch(
        //         `Failed to decode document referenced from: some/path. Reason: An instance of TestClass has failed the validation:\n - property field has failed the following constraints: isDate \n.`
        //     )

        // })
    })



})