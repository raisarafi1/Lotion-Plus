


import React, { useState, useEffect } from 'react';
import { GoogleLogin } from '@react-oauth/google';
// import { useState } from "react";
import ReactDOM from "react-dom/client";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import Layout from "./Layout";
import WriteBox from "./WriteBox";
import Empty from "./Empty";

import { googleLogout, useGoogleLogin } from '@react-oauth/google';
import axios from 'axios';
import { GoogleOAuthProvider } from "@react-oauth/google";
import { GoogleLogout } from '@react-oauth/google';


function App() {
    const [collapse, setCollapse] = useState(false);
    const [ user, setUser ] = useState([]);
    const [ profile, setProfile ] = useState([]);
    const responseMessage = (response) => {
        console.log(response);
    };
    const login = useGoogleLogin({
        onSuccess: (codeResponse) => setUser(codeResponse),
        onError: (error) => console.log('Login Failed:', error)
    });
    useEffect(
        () => {
            if (user) {
                axios
                    .get(`https://www.googleapis.com/oauth2/v1/userinfo?access_token=${user.access_token}`, {
                        headers: {
                            Authorization: `Bearer ${user.access_token}`,
                            Accept: 'application/json'
                        }
                    })
                    .then((res) => {
                        setProfile(res.data);
                    })
                    .catch((err) => console.log(err));
            }
        },
        [ user ]
    );
    const logOut = () => {
        googleLogout();
        setProfile(null);
    };
    const renderLayout = () => {
        const root = ReactDOM.createRoot(document.getElementById("root"));
  root.render(
  <>
    <BrowserRouter>
      <Routes>
        <Route element={<Layout />}>
          <Route path="/" element={<Empty />} />
          <Route path="/notes" element={<Empty />} />
          <Route
            path="/notes/:noteId/edit"
            element={<WriteBox edit={true} />}
          />
          <Route path="/notes/:noteId" element={<WriteBox edit={false} />} />
          {/* any other path */}
          <Route path="*" element={<Empty />} />
        </Route>
      </Routes>
    </BrowserRouter>
  </>
);
  document.getElementById('root')
        }
    const errorMessage = (error) => {
        console.log(error);
    };
    return (
        <div id="container">
      <header>
        <aside>
          <button id="menu-button" onClick={() => setCollapse(!collapse)}>
            &#9776;
          </button>
        </aside>
        <div id="app-header">
          <h1>
           Lotion
          </h1>
          <h6 id="app-moto">Like Notion, but worse.</h6>
        </div>
        <aside>&nbsp;</aside>
      </header>
      <div className="container">

<br />
<br />
{profile ? (
    <div className="profile">

        <GoogleLogin onSuccess={renderLayout} onError={errorMessage} />
    </div>
) : (
    <button className="login-button" onClick={() => login()}>Sign in to Lotion with Google <img className="google-icon" src="https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg" alt="Google symbol" /></button>
)}
</div>
        </div>
    )
}
export default App;