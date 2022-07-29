import React from "react";
import { useState } from "react";
import {
  Button,
  Col,
  Form,
  Row,
} from "react-bootstrap";
import { toast } from "react-toastify";
import { updateAbout } from "../../controller/api";
import Layout from "../../Layout";


import "./procedure.css";

const Procedure = () => {
const [about,setAbout]=useState();

const handle =async()=>{
  try {
    const aboutRes = await updateAbout(about);
    console.log(aboutRes)
    const { status, message} = aboutRes;
    if (status === 1) {
      toast.success(message);
    }
  } catch (error) {
    console.log(error);
  }
};
  return (
    <Layout>
      <div className="procedure-main py-4 px-5">
        <Row>
          <Col  lg={12}>
            <div className="user-data">
              <div className="user-data-header d-flex align-items-center justify-content-between">
                <h1>About</h1>
                <div className="delete-group d-flex align-items-center justify-content-end">
                  <Button onClick={handle}>Update</Button>
                </div>
              </div>
              <div className="user-data-table mt-4">
                <Form>
                  <Form.Group
                    className=''
                    controlId="" >
                    <Form.Control className="bg-transparent border-0 textarea-height" as="textarea"  onChange={(e)=>setAbout(e.target.value)} value={about} placeholder='write anything for your app' />
                    {/* <p><strong>Solution with span:</strong> <span class="textarea" role="textbox" contenteditable></span></p> */}
                  </Form.Group>
                </Form>
              </div>

            </div>
          </Col>
        </Row>
      </div>


    </Layout>
  );
};

export default Procedure;
