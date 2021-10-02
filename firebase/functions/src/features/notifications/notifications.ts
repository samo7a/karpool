
import * as admin from 'firebase-admin'
import { NotificationData } from '../../data-access/trip/schema'
import { FirestoreKey } from '../../constants'
import * as functions from 'firebase-functions'
import { NotificationsDAOInterface } from './notificationsDAO'



export function sendCustomNotification( tokenIDs:string[], data: NotificationData){
   
        tokenIDs.forEach(function(token){
            const message = {
                notification: { 
                    title: 'Karpol Notification', 
                    body: "Driver ID:"+ data.driverID + "Trip number:" + data.tripID
                },

                token: token,

                data:{
                    body:data.subject
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
    const query = await admin.firestore().collection(FirestoreKey.tripsCreated).where('startTime', '==', (currentTime - 10800000)).get()
    console.log("start query display: " )
    //const arr = query.riderStatus
    query.forEach(function(element){
        console.log(element.data)
    })

})
