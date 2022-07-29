import axios from 'axios';
import React ,{ useContext, useState }from 'react'
import { Button, Col, Form, Row } from 'react-bootstrap';
import { toast } from 'react-toastify';
import { Auth } from '../../App';
import Layout from '../../Layout'
import "./profile.css";

const Profile = () => {
    const { user ,setUserName,userName} = useContext(Auth);
    console.log(user,"----------fdfdf")
    const [password,setPassword]=useState({
        oldPassword:"",
        newPassword:"",
        conformPassword:""
    })
    const [name,setName]=useState({
        first_name:userName?.first_name,
        last_name:userName?.last_name,
       
    })
    



    const pass =(e)=>{
        e.preventDefault();
        setPassword({...password,[e.target.name]:e.target.value})
    };

    const changeName =(e)=>{
        e.preventDefault();
        setName({...name,[e.target.name]:e.target.value})
    };

    const changePass =async(e)=>{
        e.preventDefault();
        console.log("in")
        if (password.newPassword === password.conformPassword) {
        try {
            console.log("in")
               const res = await axios.patch(`/update-profile?id=${user?._id}`,{new_password:password.newPassword,old_password:password.oldPassword})
               console.log(res,"ressssssssssss-----------------")
            if (res.data.status === 1) {
                setPassword({
                    oldPassword:"",
                    newPassword:"",
                    conformPassword:""
                })
                toast.success(res.data.message)
            }else if(res.data.status === 0){
                console.log("sdsdsd")
                toast.error(res.data.message)
            }
        } catch (error) {
            console.log(error)
        }
        }else{
            console.log("in--")
            toast.error("don't match conformPassword")
        }
    };

    const updateName =async(e)=>{
        e.preventDefault();     
        try {
               const res = await axios.patch(`/update-profile?id=${user?._id}`,{first_name:name.first_name,last_name:name.last_name})
            if (res.data.status == 1) {
                setUserName(name)
                localStorage.setItem("username",JSON.stringify(name))
                toast.success(res.data.message)

            }else{
                toast.error(res.data.message)
            }
            } catch (error) {
                console.log(error)

            }
            
    }
    return (
        <Layout>
            <div className='user-main py-4 px-4'>
                <div>
                    <div className="profile-main">
                        <div className="prof-head p-4">
                            <h2>Edit Profile</h2>
                            <p>User Information</p>
                        </div>

                        <Row className='mt-3'>
                            <Col xl={8} lg={10}>
                                <Form className='p-4 pt-3'>
                                    <Form.Group className="mb-3 d-flex flex-wrap flex-sm-nowrap" controlId="name">
                                        <Form.Label>First Name</Form.Label>
                                        <Form.Control type="text" placeholder={name?.first_name ?name?.first_name:user?.first_name} value={name.first_name} name="first_name" onChange={(e)=>changeName(e)} />
                                    </Form.Group>

                                    <Form.Group className="mb-3 d-flex flex-wrap flex-sm-nowrap" controlId="name">
                                        <Form.Label>Last Name</Form.Label>
                                        <Form.Control type="text" placeholder={name?.last_name ?name?.last_name:user?.last_name} value={name.last_name} name="last_name" onChange={(e)=>changeName(e)}/>
                                    </Form.Group>

                                    <Form.Group className="mb-3 d-flex flex-wrap flex-sm-nowrap" controlId="formBasicPassword">
                                        <Form.Label>Email</Form.Label>
                                        <Form.Control type="email" placeholder={user?.email} disabled/>
                                    </Form.Group>



                                    <div className="text-end">
                                        <Button variant="primary" className='shadow-none' type="submit" onClick={updateName}>
                                            Save
                                        </Button>
                                    </div>
                                </Form>
                            </Col>
                        </Row>
                    </div>

                    <div className="profile-main">
                        <div className="prof-head p-4 pt-3">
                            <h2>Change Password</h2>
                            <p>Password</p>
                        </div>

                        <Row className='mt-3'>
                            <Col xl={8} lg={10}>
                                <Form className='p-4'>
                                    <Form.Group className="mb-3 d-flex flex-wrap flex-sm-nowrap" controlId="name">
                                        <Form.Label>Current Password</Form.Label>
                                        <Form.Control type="password" placeholder="Current Password" value={password.oldPassword} name="oldPassword" onChange={(e)=>pass(e)} />
                                    </Form.Group>

                                    <Form.Group className="mb-3 d-flex flex-wrap flex-sm-nowrap" controlId="name">
                                        <Form.Label>New Password</Form.Label>
                                        <Form.Control type="password" placeholder="New Password" value={password.newPassword} name="newPassword" onChange={(e)=>pass(e)} />
                                    </Form.Group>

                                    <Form.Group className="mb-3 d-flex flex-wrap flex-sm-nowrap" controlId="formBasicPassword">
                                        <Form.Label>Confirm New Password</Form.Label>
                                        <Form.Control type="password" placeholder="Confirm New Password" value={password.conformPassword} name="conformPassword" onChange={(e)=>pass(e)} />
                                    </Form.Group>

                                    <div className="text-end">
                                        <Button variant="primary" className='shadow-none' type="submit" onClick={changePass}>
                                            Change Password
                                        </Button>
                                    </div>
                                </Form>
                            </Col>
                        </Row>
                    </div>
                </div>
            </div>
        </Layout>
    )
}

export default Profile