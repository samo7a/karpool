import "./App.css";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import LandingPage from "./pages/Landing/LandingPage";
import AboutUsPage from "./pages/AboutUs/AboutUsPage";

function App() {
  return (
    <Router>
      <div className="App">
        <Switch>
          <Route exact path="/">
            <LandingPage />
          </Route>
          <Route exact path="/login">
            {/* <LoginPage /> */}
          </Route>
          <Route exact path="/register">
            {/* <SignupPage /> */}
          </Route>
          <Route exact path="/home">
            {/* <HomePage /> */}
          </Route>
          <Route exact path="/about-us">
            <AboutUsPage />
          </Route>
          <Route exact path="/account">
            {/* <Account /> */}
          </Route>
        </Switch>
      </div>
    </Router>
  );
}

export default App;
