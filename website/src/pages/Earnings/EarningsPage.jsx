import React, { useState, useEffect } from "react";
import "./EarningsPage.css";

import Navbar from "../../components/Navbar/Navbar";
import Footer from "../../components/Footer/Footer";

import firebase from "firebase";
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';


const EarningsPage = () => {
    const [monthlyEarnings, setMonthlyEarnings] = useState([]);
    const [weeklyEarnings, setWeeklyEarnings] = useState([]);

    const data = [
        {
            name: 'Jan.',
            // amt: 2400,
        },
        {
            name: 'Feb.',
            // amt: 2210,
        },
        {
            name: 'Mar.',
            // amt: 2290,
        },
        {
            name: 'Apr.',
            // amt: 2000,
        },
        {
            name: 'May',
            // amt: 2181,
        },
        {
            name: 'Jun.',
            // amt: 2500,
        },
        {
            name: 'Jul.',
            // amt: 2100,
        },
        {
            name: 'Aug.',
            // amt: 2100,
        },
        {
            name: 'Sep.',
            // amt: 2100,
        },
        {
            name: 'Oct.',
            // amt: 2100,
        },
        {
            name: 'Nov.',
            // amt: 2100,
        },
        {
            name: 'Dec.',
            // amt: 2100,
        },
    ];

    useEffect(async () => {
        // const getEarnings = async () => {
        var arrayMonth = [];
        var arrayWeek = [];
        const result = await firebase.functions().httpsCallable('account-getEarnings')({});
        const [weekly_earnings, monthly_earnings] = result.data
        console.log(weekly_earnings, monthly_earnings);

        // Monthly Earnings
        for (var i = 0; i < monthly_earnings.length; i++) {
            const obj = {
                name: monthly_earnings[i].month,
                amt: monthly_earnings[i].amount,
            };
            arrayMonth.push(obj);
        }
        setMonthlyEarnings(arrayMonth);

        // Weekly Earnings
        for (var i = 0; i < weekly_earnings.length; i++) {
            const obj = {
                name: weekly_earnings[i].weekNum,
                amt: weekly_earnings[i].amount,
            };
            arrayWeek.push(obj);
        }
        setWeeklyEarnings(arrayWeek);

        // }
        // getEarnings();
    }, []);

    return (
        <>
            <div className="content">
                <Navbar />
                <h1>Driver Earnings</h1>
                <h2>Monthly Earnings</h2>
                <div id="charts">
                    <LineChart width={1300} height={300} data={monthlyEarnings}>
                        <XAxis dataKey="name" />
                        <YAxis />
                        <CartesianGrid stroke="#bcbcbc" strokeDasharray="1 1" />
                        <Line type="monotone" dataKey="amt" stroke="#8884d8" />
                    </LineChart>
                </div>
                <h2>Weekly Earnings</h2>
                <div id="charts">
                    <LineChart width={1300} height={300} data={weeklyEarnings}>
                        <XAxis dataKey="name" />
                        <YAxis />
                        <CartesianGrid stroke="#bcbcbc" strokeDasharray="1 1" />
                        <Line type="monotone" dataKey="amt" stroke="#8884d8" />
                    </LineChart>
                </div>
                <Footer />
            </div>
        </>
    );
};

export default EarningsPage;