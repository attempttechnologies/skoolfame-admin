import React, { useState } from 'react'
import { Outlet } from 'react-router-dom'
import Header from './Components/header/Header'
import Sidebar from './Components/sidebar/Sidebar'

const Layout = (props) => {

  const [toggle, setToggle] = useState(false)

  return (
    <div>


        <Sidebar toggle={toggle} setToggle={setToggle}/>

        <main className='dashboard-main'>

            {
                <Header setToggle={setToggle} toggle={toggle}/>
            }
       
            {props.children}

        </main>


    </div>
  )
}

export default Layout