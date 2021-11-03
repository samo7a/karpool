import React, { useState, useEffect } from "react";
import "./DriverRideHistoryPage.css";
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



const DriverRideHistoryPage = () => {
    const [trips, setTrips] = useState([])

    useEffect(() => {
        const getTrips = async () => {
            var array = [];
            const getTrips = firebase.functions().httpsCallable('trip-getCompletedTrips');
            const data = {
                isDriver: true
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
                    <Avatar alt="Bob" src={"/static/images/avatar/1.jpg"} />
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
                            {trip.startAddress}
                            <br></br>
                            {trip.endAddress}
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
                <div className="content">
                    <div className="wrapper">
                        <h1>Driver Ride History</h1>
                    </div>
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
export default DriverRideHistoryPage;