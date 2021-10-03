import * as admin from 'firebase-admin'
import { FirestoreKey } from '../../constants'
import { FCMTokens } from '../../data-access/trip/schema'




export interface NotificationsDAOInterface{

    // createToken(userID: string, data: FCMTokens): Promise < string >
     getTokenList(userIDs:string[]) : Promise <string[]>

}


export class NotificationsDAO implements NotificationsDAOInterface{

db: admin.firestore.Firestore

constructor(db: admin.firestore.Firestore){
    this.db = db
}


// async createToken(userID: string, data: FCMTokens): Promise < string >{

//     const tokenRef = this.db.collection(FirestoreKey.FCMTokens).doc(userID)
//     await tokenRef.create(data)
//     return tokenRef.id
// }


     async getTokenList(userIDs: string[]): Promise<string[]>{

    const arr: string[] = []
    let i:number = 0
        for(i=0; i < userIDs.length; i++){

          const query = await this.db.collection(FirestoreKey.FCMTokens).doc(userIDs[i]).get()



            if (query.exists) {
                const Arr2 = query.data() as FCMTokens
                console.log(Arr2)
                Arr2.tokenIDs.forEach((e)=>{
                    arr.push(e)
                    console.log(arr) 
                })      
            } else {
                // doc.data() will be undefined in this case
                console.log("No such document!")
            }
        }
       // arr.push("test 2")
       //console.log(arr) 

        if(arr.length === 0){
            console.log("No available tokens")
        }
        
        return arr 
}

}
