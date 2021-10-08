
import * as admin from 'firebase-admin'

import { NotificationData, CreatedTripSchema } from '../../data-access/trip/schema'
import { FirestoreKey } from '../../constants'
import * as functions from 'firebase-functions'
import { newNotificationDAO } from '../..'





// Function to send the notification. this is a private function used only inside code
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

//Function to send notification to users 3 hours before the trip's start
export const sendTripThreeHoursNotifiction = functions.pubsub.schedule('* * * * *').onRun( async (context)=>{

    const currentTime = new Date()
    currentTime.setHours(currentTime.getHours() + 3)

    //console.log(currentTime)
    const query = await admin.firestore().collection(FirestoreKey.tripsCreated).where('startTime', '<=', currentTime).where('notifThree','==', false).get()
    //console.log("start query display: ")

    const trips = query.docs.map(doc => doc.data()) as CreatedTripSchema[]

    //console.log(trips)
    //console.log("End query display: ")
    if(trips.length > 0){
           await Promise.all(trips.map(async e =>{
                const tripIDs : string[] = []
                const snapshot = e.riderInfo
                e.notifThree = true
                await newTripDAO().updateCreatedTrip(e.docID, e )
                snapshot.forEach((element)=>{
                    tripIDs.push(element.riderID)
                })
                tripIDs.push(e.driverID)
                   // console.log(tripIDs)
                const tokens =  await newNotificationDAO().getTokenList(tripIDs)

                //console.log(tokens)
                    const message  = {
                        subject: "Your scheduled trip will start in about three(3) hours",
                        driverID : e.driverID,
                        tripID: e.docID,
                        notificationID: 2
                    }           
                    sendCustomNotification(tokens, message)
            }))
        }
   
})


//Function to send notification to users 30 minutes before the trip's start

export const sendTripThirtyMinutesNotifiction = functions.pubsub.schedule('* * * * *').onRun( async (context)=>{

    const currentTime = new Date()
    currentTime.setMinutes(currentTime.getMinutes() + 30)

    //console.log("=====" + currentTime)
    const query = await admin.firestore().collection(FirestoreKey.tripsCreated).where('startTime', '<=', currentTime).where('notifThirty','==', false).get()
   // console.log("start query display: ")

    const trips = query.docs.map(doc => doc.data()) as CreatedTripSchema[]

   // console.log("End query display: ")
    if(trips.length > 0){

        //console.log("Inside if statement")
           await Promise.all(trips.map(async e =>{
                const tripIDs : string[] = []
                const snapshot = e.riderInfo
                e.isOpen =  false
                e.notifThirty = true
                await newTripDAO().updateCreatedTrip(e.docID, e )
                snapshot.forEach((element)=>{
                    tripIDs.push(element.riderID)
                })
                tripIDs.push(e.driverID)
                   // console.log(tripIDs)
                const tokens =  await newNotificationDAO().getTokenList(tripIDs)

                //console.log(tokens)
                    const message  = {
                        subject: "Your scheduled trip will start in about thirthy(30) minutes",
                        driverID : e.driverID,
                        tripID: e.docID,
                        notificationID: 2
                    }           
                    sendCustomNotification(tokens, message)
            }))
        }
   
})
