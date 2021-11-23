import React, { useState, useEffect } from "react";
import "./RiderRideHistoryPage.css";
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import Divider from '@mui/material/Divider';
import ListItemText from '@mui/material/ListItemText';
import ListItemAvatar from '@mui/material/ListItemAvatar';
import Avatar from '@mui/material/Avatar';
import Typography from '@mui/material/Typography';



import Navbar from "../../components/Navbar/Navbar";
import Footer from "../../components/Footer/Footer";

import firebase from "firebase";



const RiderRideHistoryPage = () => {
    const [trips, setTrips] = useState([])

    useEffect(() => {
        const getTrips = async () => {
            var array = [];
            const getTrips = firebase.functions().httpsCallable('trip-getCompletedTrips');
            const data = {
                isDriver: false
            }
            const result = await getTrips(data);
            console.log(result.data)
            for (var i = 0; i < result.data.length; i++) {
                const fireBaseTime = new Date(
                    result.data[i]["startTime"]["_seconds"] * 1000 + result.data[i]["startTime"]["_nanoseconds"] / 1000000,
                );
                const date = fireBaseTime.toDateString();
                const atTime = fireBaseTime.toLocaleTimeString();
                const obj = {
                    key: i,
                    endAddress: result.data[i]["endAddress"],
                    startAddress: result.data[i]["startAddress"],
                    date: date,
                    time: atTime,

                }

                array.push(obj);
            }
            setTrips(array);
            console.log("array", array)
            console.log("trips", trips)
        }
        getTrips()
        console.log("trips", trips)

    }, []);
    const tripItems = trips.map((trip, index) =>
        <>
            <ListItem alignItems="flex-start"
                key={index}
            >
                <ListItemAvatar>
                    <Avatar src={"/static/images/avatar/1.jpg"} />
                </ListItemAvatar>
                <ListItemText
                    secondary={
                        <React.Fragment>
                            {trip.date}
                            <br></br>
                            {trip.time}
                            <Typography
                                sx={{ display: 'inline' }}
                                component="span"
                                variant="body2"
                                color="text.primary"
                            >
                                <br></br>
                                {/* {"Rider Name"} */}
                                {/* <br></br> */}
                            </Typography>
                            From: {trip.startAddress}
                            <br></br>
                            To: {trip.endAddress}
                            <br></br>
                        </React.Fragment>
                    }
                />
            </ListItem>
            <Divider variant="inset" component="li" />
        </>);

    return (
        <>
            <div className="content">
                <Navbar />
                <h1>Rider Ride History</h1>
                <div className="content">
                    <List sx={{
                        width: '100%',
                        bgcolor: 'background.paper',
                        position: 'relative',
                        overflow: 'auto',
                        maxHeight: 600,
                        '& ul': { padding: 0 },
                    }}>
                        {tripItems}
                    </List>
                </div>
                <Footer />
            </div>
        </>
    );
};
export default RiderRideHistoryPage;