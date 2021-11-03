import "./App.css";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import ProtectedRoute from "./auth/ProtectedRoute";
import ProtectedHome from "./auth/ProtectedHome";
import { useAuth } from "./auth/useAuth";
import LandingPage from "./pages/Landing/LandingPage";
import AboutUsPage from "./pages/AboutUs/AboutUsPage";
import SignupPage from "./pages/Signup/SignupPage";
import LoginPage from "./pages/Login/LoginPage";
import ResetPasswordPage from "./pages/ResetPassword/ResetPasswordPage";
import NotFoundPage from "./pages/NotFound/NotFoundPage";
import RiderHomePage from "./pages/RiderHome/RiderHomePage";
import DriverHomePage from "./pages/DriverHome/DriverHomePage";
import DriverRideHistoryPage from "./pages/DriverRideHistory/DriverRideHistoryPage";
import RiderRideHistoryPage from "./pages/RiderRideHistory/RiderRideHistoryPage";
import PaymentInfoPage from "./pages/PaymentInfo/PaymentInfoPage";
import BankInfoPage from "./pages/BankInfo/BankInfoPage";
import EarningsPage from "./pages/Earnings/EarningsPage";
import DepositsPage from "./pages/Deposits/DepositsPage";
import AccountPage from "./pages/Account/AccountPage";
import VehicleInfoPage from "./pages/CarInfo/CarInfoPage";


import { transitions, positions, Provider as AlertProvider } from "react-alert";
import AlertTemplate from "react-alert-template-basic";
const options = {
  position: positions.BOTTOM_CENTER,
  timeout: 2500,
  offset: "30px",
  transition: transitions.SCALE,
};

function App() {
  const { isLoading, user } = useAuth();
  return (
    <AlertProvider template={AlertTemplate} {...options}>
      <Router>
        <div className="App">
          <Switch>
            <Route exact path="/">
              <LandingPage />
            </Route>
            <Route exact path="/reset-password">
              <ResetPasswordPage />
            </Route>
            <Route exact path="/login">
              <LoginPage />
            </Route>
            <Route exact path="/register">
              <SignupPage />
            </Route>
            {/*for authenticated users only*/}
            <ProtectedHome
              isAuthed={!!user}
              isLoading={isLoading}
              exact
              path="/driver-home"
            >
              <DriverHomePage />
            </ProtectedHome>
            <ProtectedHome
              isAuthed={!!user}
              isLoading={isLoading}
              exact
              path="/rider-home"
            >
              <RiderHomePage />
            </ProtectedHome>
            <ProtectedRoute
              isAuthed={!!user}
              isLoading={isLoading}
              exact
              path="/about-us"
            >
              <AboutUsPage />
            </ProtectedRoute>
            <ProtectedRoute
              isAuthed={!!user}
              isLoading={isLoading}
              exact
              path="/account"
            >
              {<AccountPage />}
            </ProtectedRoute>
            <ProtectedRoute
              isAuthed={!!user}
              isLoading={isLoading}
              exact
              path="/driver-ride-history"
            >
              {<DriverRideHistoryPage />}
            </ProtectedRoute>
            <ProtectedRoute
              isAuthed={!!user}
              isLoading={isLoading}
              exact
              path="/rider-ride-history"
            >
              {<RiderRideHistoryPage />}
            </ProtectedRoute>
            <ProtectedRoute
              isAuthed={!!user}
              isLoading={isLoading}
              exact
              path="/payment-info"
            >
              {<PaymentInfoPage />}
            </ProtectedRoute>
            <ProtectedRoute
              isAuthed={!!user}
              isLoading={isLoading}
              exact
              path="/bank-info"
            >
              {<BankInfoPage />}
            </ProtectedRoute>
            <ProtectedRoute
              isAuthed={!!user}
              isLoading={isLoading}
              exact
              path="/earnings"
            >
              {<EarningsPage />}
            </ProtectedRoute>
            <ProtectedRoute
              isAuthed={!!user}
              isLoading={isLoading}
              exact
              path="/deposits"
            >
              {<DepositsPage />}
            </ProtectedRoute>
            <ProtectedRoute
              isAuthed={!!user}
              isLoading={isLoading}
              exact
              path="/car-info"
            >
              {<VehicleInfoPage />}
            </ProtectedRoute>
            <Route path="*">
              <NotFoundPage />
            </Route>
          </Switch>
        </div>
      </Router>
    </AlertProvider>
  );
}

export default App;
