import React, { useState, useEffect } from "react";
import "./DepositsPage.css";
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

const DepositsPage = () => {
    // const [deposits, setDeposits] = useState([])

    // // useEffect(() => {
    // //     const getDeposits = async () => {
    // //         var array = [];
    // //         const result = await firebase.functions().httpsCallable('account-getDeposits')({});
    // //         const [weekly_earnings, monthly_earnings] = result.data

    // //         console.log(weekly_earnings, monthly_earnings)
    // //         //{date:'2021-11-19T02:32:04.103Z'}
    // //     }
    // //     getDeposits();
    // // });

    return (
        <>
            <div className="content">
                <Navbar />
                <h1>Driver Deposits</h1>
                <div className="content">
                    <List sx={{
                        width: '100%',
                        bgcolor: 'background.paper',
                        position: 'relative',
                        overflow: 'auto',
                        maxHeight: 600,
                        '& ul': { padding: 0 },
                    }}>
                        <ListItem alignItems="flex-start">
                            <ListItemAvatar>
                                <Avatar alt="Steve Bob" src="/static/images/avatar/1.jpg" />
                            </ListItemAvatar>
                            <ListItemText
                                secondary={
                                    <React.Fragment>
                                        <Typography
                                            sx={{ display: 'inline' }}
                                            component="span"
                                            variant="body2"
                                            color="text.primary"
                                        >
                                            Time and Date:
                                            <br></br>
                                        </Typography>
                                        {"Transferred To:"}
                                    </React.Fragment>
                                }
                            />
                        </ListItem>
                        <Divider variant="inset" component="li" />
                        <ListItem alignItems="flex-start">
                            <ListItemAvatar>
                                <Avatar alt="Steve Bob" src="/static/images/avatar/1.jpg" />
                            </ListItemAvatar>
                            <ListItemText
                                secondary={
                                    <React.Fragment>
                                        <Typography
                                            sx={{ display: 'inline' }}
                                            component="span"
                                            variant="body2"
                                            color="text.primary"
                                        >
                                            Time and Date:
                                            <br></br>
                                        </Typography>
                                        {"Transferred To:"}
                                    </React.Fragment>
                                }
                            />
                        </ListItem>
                        <Divider variant="inset" component="li" />
                        <ListItem alignItems="flex-start">
                            <ListItemAvatar>
                                <Avatar alt="Steve Bob" src="/static/images/avatar/1.jpg" />
                            </ListItemAvatar>
                            <ListItemText
                                secondary={
                                    <React.Fragment>
                                        <Typography
                                            sx={{ display: 'inline' }}
                                            component="span"
                                            variant="body2"
                                            color="text.primary"
                                        >
                                            Time and Date:
                                            <br></br>
                                        </Typography>
                                        {"Transferred To:"}
                                    </React.Fragment>
                                }
                            />
                        </ListItem>
                    </List>
                </div>
                <Footer />
            </div>
        </>
    );
};
export default DepositsPage;