

import React from "react";
import ReactDOM from "react-dom";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import "./index.css";
import Layout from "./Layout";
import WriteBox from "./WriteBox";
import Empty from "./Empty";
import reportWebVitals from "./reportWebVitals";
import { GoogleOAuthProvider } from "@react-oauth/google";
import App from "./App";



const root = ReactDOM.createRoot(document.getElementById("root"));


root.render(
  <>
  {/* <GoogleOAuthProvider clientId="463122565328-km4ea940dujvniojpe8rrc1aljg5u3v8.apps.googleusercontent.com"> */}
  <GoogleOAuthProvider clientId="463122565328-km4ea940dujvniojpe8rrc1aljg5u3v8.apps.googleusercontent.com">
    <React.StrictMode>
        <App />
    </React.StrictMode>
  </GoogleOAuthProvider>
  { document.getElementById('root') }
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
          {/ any other path /}
          <Route path="" element={<Empty />} />
        </Route>
      </Routes>
    </BrowserRouter>
  </>
);



ReactDOM.render(
  <GoogleOAuthProvider clientId="463122565328-km4ea940dujvniojpe8rrc1aljg5u3v8.apps.googleusercontent.com">
    <React.StrictMode>
      <div className="container">
        <App />
      </div>
    </React.StrictMode>
  </GoogleOAuthProvider>,
  document.getElementById('root')
);

reportWebVitals();






