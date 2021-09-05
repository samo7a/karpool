import "./App.css";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import ProtectedRoute from "./auth/ProtectedRoute";
import { useAuth } from "./auth/useAuth";
import LandingPage from "./pages/Landing/LandingPage";
import AboutUsPage from "./pages/AboutUs/AboutUsPage";
import SignupPage from "./pages/Signup/SignupPage";
import LoginPage from "./pages/Login/LoginPage";
import ResetPasswordPage from "./pages/ResetPassword/ResetPasswordPage";
import NotFoundPage from "./pages/NotFound/NotFoundPage";
import VerifyEmailPage from "./pages/VerifyEmail/VerifyEmailPage";

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
            <Route exact path="/verify-email">
              <VerifyEmailPage />
            </Route>
            <Route exact path="/login">
              <LoginPage />
            </Route>
            <Route exact path="/register">
              <SignupPage />
            </Route>
            {/*for authenticated users only*/}
            <ProtectedRoute
              isAuthed={!!user}
              isLoading={isLoading}
              exact
              path="/driver-home"
            >
              {/* <HomePage /> */}
            </ProtectedRoute>
            <ProtectedRoute
              isAuthed={!!user}
              isLoading={isLoading}
              exact
              path="/rider-home"
            >
              {/* <HomePage /> */}
            </ProtectedRoute>
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
              {/* <Account /> */}
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
