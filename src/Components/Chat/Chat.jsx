import React, { useEffect, useRef, useState } from 'react'
import "./chat.css";
import Layout from '../../Layout'
import { Col, Row, } from "react-bootstrap";
import { IoArrowBackOutline } from 'react-icons/io5'
import { getAllUser, getChatById, getChatuser } from '../../controller/api';
import { useParams } from 'react-router-dom';
import moment from "moment";
import localization from 'moment/locale/en-in';
const chat = () => {
    const [users,setUsers]=useState([]);
    const [susers,setSUsers]=useState([]);
    const [chats,setChats]=useState(null);
    const [name,setName]=useState(null);
    const [searchData,setSearchData]=useState("");
    const ref =useRef(null);
 const pf = process.env.REACT_APP_PUBLIC_URL;
//  const pf = "http://192.168.40.160:3000"
    const {id}=useParams()
    moment.updateLocale('en-in', localization);

    const getUser=async()=>{
        try {
            const user =await getChatuser(id);
            const {status,data}=user;

            if(status==1){
                setUsers(data)
                setSUsers(data)
                console.log("conver---------",data)
            }
        } catch (error) {
            
        }
    }
    const getChat=async(id,name)=>{
        try {
            setName(name)
            const user =await getChatById(id);
            const {status,data}=user;

            if(status==1){
                setChats(data.reverse())
                console.log("chatttt---------",data)
            }
        } catch (error) {
            
        }
    }



    useEffect(() => {
     getUser()
    //  ref.current?.scrollIntoView({ behavior: "smooth" });
    }, [])
    useEffect(() => {
       searchData ? setUsers(susers.filter((a)=>new RegExp(searchData,"i").test(a?.user_name))):setUsers(susers)
    }, [searchData])
    useEffect(() => {
    
     ref.current?.scrollIntoView({ behavior: "smooth" });
    }, [chats])
    
    return (

        <Layout>
            <div className="user-main py-4 px-4">
                <div className='main-chat'>
                    <Row>
                        <Col xl={4} lg={5} md={6}>
                            <div className='chat-bg px-4 pt-4 pb-2'>
                                <input type="text" className='search' value={searchData}onChange={(e)=>setSearchData(e.target.value)} />

                                <div className='chat-box-scroll'>
                                    {users ? users?.map((u,i)=>{
                                        const{data_id,user_name,user_image,lastmessage}=u
                                        return(
                                            <div className="chat-bar" key={data_id} onClick={()=>getChat(data_id,user_name)}>
                                        <div className='d-flex align-items-center gap-3'>
                                            <img  src={
                                                         user_image
                                                           ? `${pf}/${user_image}`
                                                           : "../images/user.png"
                                                       }
                                             className='chat-img' alt="" />
                                            <div>
                                                <h6>{user_name}</h6>
                                                <p>{lastmessage?.message} </p>
                                            </div>
                                        </div>

                                        <div>
                                            <span className="time"> {moment(lastmessage?.createdAt).format('LL')}</span>
                                        </div>
                                    </div>

                                    )}):<h1>no conversation</h1>}
                                    


                                    

                                </div>
                            </div>
                        </Col>

                        <Col xl={8} lg={7} md={6} className="mt-md-0 mt-5">
                            <div className='chat-window'>
                                <div className="chat-header">
                                    <button className='backrow shadow-none  border-0'>
                                        <IoArrowBackOutline />
                                    </button>
                                   { name && <h6>{name}</h6>}
                                </div>


                                <div className='mt-5 chat-window-scroll' id={!name?"dd":""} >

                                    {chats && chats?.map((c,i)=>{
                                        const{sender_user,_id,receiver_user,message}=c;
                                        const createdAt = 10000000000
                                        if (id === sender_user._id) {
                                            return(
                                                <div className="chat-left" key={i} ref={ref}>
                                                   <div className="chat-inner">
                                                <div className='d-flex align-items-center gap-3' style={{width:"100%"}}>
                                                    <img src={
                                                         sender_user?.user_profile_image
                                                           ? `${pf}/${sender_user?.user_profile_image}`
                                                           : "../images/user.png"
                                                       } className='chat-img' alt="" />
                                                    <h1 style={{dispaly:"block",width:"82%"}}>
                                                        <h6 className='new-h6'> <h6>{sender_user?.first_name+""+sender_user?.last_name} </h6><div >
                                                    <span className="time"> {moment(createdAt).format('lll')}</span>
                                                </div></h6>
                                                        <p id="breakword">{message }</p>
                                                    </h1>
                                                </div>
    
                                                
                                            </div>
                                                </div>)
                                            
                                        }else{
                                            return(  <div className="chat-right" ref={ref}>
                                            <div className="chat-inner">
                                                <div className='d-flex align-items-center gap-3' style={{width:"100%"}}>
                                                    <img src={
                                                         sender_user?.user_profile_image
                                                           ? `${pf}/${sender_user?.user_profile_image}`
                                                           : "../images/user.png"
                                                       } className='chat-img' alt="" />
                                                    <h1 style={{dispaly:"block",width:"82%"}}>
                                                        <h6 className='new-h6'> <h6>{sender_user?.first_name+""+sender_user?.last_name} </h6><div >
                                                    <span className="time"> {moment(createdAt).format('lll')}</span>
                                                </div></h6>
                                                        <p id="breakword">{message }</p>
                                                    </h1>
                                                </div>
    
                                                
                                            </div>
                                        </div>)
                                           
                                           
                                        }
                                    })}

                                  
{!name && <h1 style={{textAlign:"center"}}>select user</h1>}


                                </div>
                            </div>
                        </Col>
                    </Row>
                </div>
            </div>
        </Layout>
    )
}

export default chat