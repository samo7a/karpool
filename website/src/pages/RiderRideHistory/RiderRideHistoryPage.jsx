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

const RiderRideHistoryPage = () => {
    return (
        <>
            <div className="content">
                <Navbar />
                <div className="content">
                    <div className="wrapper">
                        <h1>Rider Ride History</h1>
                    </div>
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
                                            Driver Name
                                            <br></br>
                                            Location
                                            <br></br>
                                        </Typography>
                                        {"To:"}
                                        <br></br>
                                        {"From:"}
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
                                            Driver Name
                                            <br></br>
                                            Location
                                            <br></br>
                                        </Typography>
                                        {"To:"}
                                        <br></br>
                                        {"From:"}
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
                                            Driver Name
                                            <br></br>
                                            Location
                                            <br></br>
                                        </Typography>
                                        {"To:"}
                                        <br></br>
                                        {"From:"}
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
export default RiderRideHistoryPage;