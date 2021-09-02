import "./App.css";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import ProtectedRoute from "./auth/ProtectedRoute";
import { useAuth } from "./auth/useAuth";
import LandingPage from "./pages/Landing/LandingPage";
import AboutUsPage from "./pages/AboutUs/AboutUsPage";
import SignupPage from "./pages/Signup/SignupPage";
import LoginPage from "./pages/Login/LoginPage";

function App() {
  const { isLoading, user } = useAuth();
  return (
    <Router>
      <div className="App">
        <Switch>
          <Route exact path="/">
            <LandingPage />
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
        </Switch>
      </div>
    </Router>
  );
}

export default App;
