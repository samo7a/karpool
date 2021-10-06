
import * as admin from 'firebase-admin'
import { CreatedTripSchema, NotificationData } from '../../data-access/trip/schema'
 import { FirestoreKey } from '../../constants'
 import * as functions from 'firebase-functions'
 import { newNotificationDAO } from '../..'





export function sendCustomNotification( tokenIDs:string[], data: NotificationData){
   
        tokenIDs.forEach(function(token){
            const message = {
                notification: { 
                    title: 'Karpool Notification', 
                    body: data.subject
                },

                token: token,

                data:{
                    body:"Driver ID: "+ data.driverID + "Trip number: " + data.tripID
                }

            }
            admin.messaging().send(message).
            then(response =>{
                console.log("Message sent successfully")
            }).
            catch(error =>{
                console.log("Error sending Message")
            })
        })

      
 
}


export const sendTripThreeHoursNotifiction = functions.pubsub.schedule('* * * * *').onRun( async (context)=>{

    const currentTime = new Date().getTime()
    const query = await admin.firestore().collection(FirestoreKey.tripsCreated).where('startTime', '<=', (currentTime - 10800000)).get()
    console.log("start query display: ")

    const trips = query.docs.map(doc => doc.data()) as CreatedTripSchema[]

    console.log(trips)

    if(trips.length === 0){
        console.log("No available trips")
    }else{

           await Promise.all(trips.map(async e =>{
                const tripIDs : string[] = []
                const snapshot = e.riderInfo

                snapshot.forEach((element)=>{
                    tripIDs.push(element.riderID)
                })
                tripIDs.push(e.driverID)

                const tokens =  await newNotificationDAO().getTokenList(tripIDs)

                console.log(tokens)
                    const message  = {
                        subject: "Your scheduled trip will start in three(3) hours",
                        driverID : e.driverID,
                        tripID: e.docID,
                        notificationID: 2
                    }           
                    sendCustomNotification(tokens, message)
            }))
        }
   
})
