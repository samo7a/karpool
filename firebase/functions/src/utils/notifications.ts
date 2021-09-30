
import * as admin from 'firebase-admin'

export function sendNotification(userID:string, tokenIDs:string[], data:any){
   
    tokenIDs.forEach(function(token){
    const message = {
       notification: { title: 'Karpol Notification', body: data},

       token: token,

       data:{click_action:'FLUTTER_NOTIFICATION_CLICK'}

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