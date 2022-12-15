import React, { useEffect, useState } from "react";
import { BrowserRouter, Route, Routes, Outlet, Navigate, HashRouter } from "react-router-dom";
import axios from "axios"
import "bootstrap/dist/css/bootstrap.min.css";
import "./App.css";
import Login from "./Components/login/Login";
import Dashboard from "./Components/Dashboard/Dashboard";
import User from "./Components/user/User";
import About from "./Components/procedure/About";
import Chat from "./Components/Chat/Chat";
import Profile from "./Components/Profile/Profile";
import UserDetails from "./Components/user/UserDetails/UserDetails";
import { createContext } from "react";
import { ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import School_Requests from "./Components/school/School_Requests/School_Requests";
import SchoolDetails from "./Components/school/SchoolDetail/SchoolDetail";
import Schools from "./Components/school/schools/Schools";
import Nominees from "./Components/school/Nominees/Nominees";
import Notfound from "./Components/notfound/Notfound";

export const Auth = createContext();

const App = () => {
  const [user, setUser] = useState(JSON.parse(localStorage.getItem('user') ?? null));
  const [userName, setUserName] = useState(JSON.parse(localStorage.getItem('username')));
  const [token, setToken] = useState(localStorage.getItem('token'));
  const AuthToken = localStorage.getItem('token') ? `Bearer ${localStorage.getItem('token')}` : "";

  // axios.defaults.baseURL = "http://192.168.40.160:3000/admin"
   axios.defaults.baseURL = `${window.location.origin}/admin`;
  //  process.env.REACT_APP_API_URL    #REACT_APP_PUBLIC_URL="http://192.168.40.160:3000"
  axios.defaults.headers.Authorization = AuthToken;
  
  const Home = () => {
    return (
      <>
        <Outlet />
      </>
    )
  };


  return (
    <>
      <ToastContainer />
      <Auth.Provider value={{ token, setToken, user, setUser,userName,setUserName }}>
        <HashRouter>
          <Routes>
            <Route exact path="/" element={user ? <Home /> : <Navigate to="/login" />} >
              <Route index element={<Dashboard />} />
              <Route exact path="/dashboard" element={<Dashboard />} />
              <Route exact path="/users" element={<User />} />
              <Route exact path="/profile" element={<Profile/>} />
              <Route exact path="/schools" element={<Schools />} />
              <Route exact path="/request-schools" element={<School_Requests />} />
              <Route exact path="/about" element={<About />} />
              <Route exact path="/chat/:id" element={<Chat />} />
              <Route exact path="/nominees/:id" element={<Nominees />} />
              <Route exact path="/userdetails/:id" element={<UserDetails />} />
              <Route exact path="/Superlatives/:id" element={<SchoolDetails />} />
            </Route>
            <Route exact path="/login" element={user ?  <Navigate to="/" /> : <Login />} />
            <Route path="*" element={<Notfound />} />
           
          </Routes>
        </HashRouter>
      </Auth.Provider>
    </>
  );
};

export default App;
