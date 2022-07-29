import React, { useEffect, useState } from "react";
import {  Button,  Col,  Modal,  NavLink,  Pagination,  Row,  Table,  Form,} from "react-bootstrap";
import Layout from "../../../Layout";
import { GrFormClose } from "react-icons/gr";
import "./document.css";
import { Link } from "react-router-dom";
import moment from "moment";
import { toast } from "react-toastify";
import Pagination_new from "../../Pagination_new";
import { getAllSchool } from "../../../controller/api";
import localization from "moment/locale/en-in";
import LoadingSpinner from "../../LoadingSpinner/LoaderSpinner";
import axios from "axios";


const Document = () => {
  const [show, setShow] = useState(false);
  const [searchData, setSearchData] = useState("");
  const [allSchools, setAllSchools] = useState([]);
  const [paginationVal, setPaginationVal] = useState(1);
  const [current_page, setCurrent_page] = useState(1);
  const [loading, setLoading] = useState(true);
  const [address, setAddress] = useState("");
  const [name, setName] = useState("");
  const [togel, setTogel] = useState(true);
  const perPage = 10;
  const pf = process.env.REACT_APP_PUBLIC_URL;
  moment.updateLocale("en-in", localization);

  // METHODS

  const handleClose = () => setShow(false);
  const handleShow = () => setShow(true);

  const rever = () => {
    console.log(" time time out-------")
    setAllSchools(allSchools.reverse())

  }

  const addSchool = async (pages) => {
    if (togel == false) {
      setTogel(true)
    }
try {
  const SchoolData = await axios.post("/add-school", {name,address});
  if(SchoolData.data.status == 1){
   
    setAddress("")
    setName("")
    setShow(false)
    toast.success("Add successfully")
  }
} catch (error) {
  
}
  }
  const AllSchool = async (pages) => {
    try {
      const SchoolData = await getAllSchool(perPage, pages, searchData);
      const {
        status,
        message,
        data,
        count,
        pagination_value,
        current_page: page,
      } = SchoolData;
      if (status === 1) {
        setAllSchools(data);
        console.log("allUser----------", data);
        setPaginationVal(pagination_value);
        setCurrent_page(page);
        setLoading(false);
      } else {
        toast.error(message);
        setLoading(false);
      }
    } catch (error) {
      console.log(error);
    }
  };

  useEffect(() => {
    console.log("hii user-----------");
    AllSchool();
  }, [searchData]);

  useEffect(() => {
    rever()
  }, [togel, allSchools]);


  return (
    <Layout>
      <div className="document-main py-4 px-5">
        <Row>
          <Col lg={12}>
            <div className="user-data">
              <div className="user-data-header d-flex align-items-center justify-content-between">
                <h1>Schools</h1>
                <input
                  type="text"
                  value={searchData}
                  onChange={(e) => setSearchData(e.target.value)}
                />
              </div>
              <div className="user-data-table mt-4">
                <Table responsive className="mb-0 px-4 pb-2">
                  <thead>
                    <tr>
                      <th className="p-0">
                        <span className="d-block py-3 px-5">Name</span>
                      </th>
                      <th className="p-0">
                        <span className="d-flex py-3 px-5">
                          Create At
                          <Button className="bg-transparent border-0 shadow-none p-0" onClick={() => setTogel((toge) => !toge)}>
                            <img src="./images/sorting-new.png" alt="" />
                          </Button>
                        </span>
                      </th>
                      <th className="p-0">
                        <span className="d-block py-3 px-5">Superlatives</span>
                      </th>
                      <th className="p-0">
                        <span className="d-block py-3 px-5">School Users</span>
                      </th>
                      <th className="p-0">
                        <span className="d-flex align-items-center justify-content-end px-5">
                          <Button
                            onClick={handleShow}
                            className="btn-plus shadow-none"
                          >
                            +
                          </Button>
                        </span>
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    {!loading &&
                      allSchools.length !== 0 &&
                      allSchools?.map((school) => {
                        const {
                          _id,
                          school_profile_image,
                          name,
                          createdAt,
                          users,
                          superlatives,
                          school_user
                        } = school;

                        return (
                          <tr key={_id}>
                            <td className="bg-orange">
                              <div className="delete-group ">
                                <Link
                                  to={`/schooldetail/${_id}`}
                                  className="p-0 text-decoration-none"
                                >
                                  <span className="d-block">{name}</span>
                                </Link>
                              </div>
                            </td>
                            <td className="bg-orange">
                              <span className="d-block py-3 px-5">
                                {moment(createdAt).format("L")}
                              </span>
                            </td>
                            <td className="bg-orange">
                              <span className="d-block py-3 px-5">
                                {superlatives?.length}
                              </span>
                            </td>
                            <td className="bg-orange">
                              <span className="d-block py-3 px-5">
                                {school_user?school_user:"0"}
                              </span>
                            </td>
                            <td className="bg-orange">
                              <div className="delete-group d-flex align-items-center justify-content-end gap-3">
                                <Link
                                  to={`/schooldetail/${_id}`}
                                  className="d-flex align-items-center gap-3 p-0 text-decoration-none">
                                  <Button className="shadow-none">Info</Button>
                                </Link>
                              </div>
                            </td>
                          </tr>
                        );
                      })}
                  </tbody>
                </Table>
              </div>
              {loading ? (
                <h1 className="lod">
                  <LoadingSpinner />
                </h1>
              ) : allSchools.length === 0 ? (
                <h1 className="lod">no data available of schools</h1>
              ) : null}
              <div className="d-flex justify-content-end mt-4">
                <Pagination_new
                  AllUser={AllSchool}
                  pagination={paginationVal}
                  current_page={current_page}
                />
              </div>
            </div>
          </Col>
        </Row>
      </div>

      <Modal
        show={show}
        onHide={handleClose}
        centered
        className="modal_superlative" >
        <Modal.Header closeButton>
          <Modal.Title>Add School</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <Form>
            <Form.Group controlId="formGridEmail">
              <Form.Label>Name</Form.Label>
              <Form.Control type="text" placeholder="Name" required="true" value={name} onChange={(e)=>setName(e.target.value)}/>
            </Form.Group>
            <Form.Group controlId="formGridEmail" className="mt-4">
              <Form.Label>Address</Form.Label>
              <Form.Control type="text" placeholder="Address" required="true" value={address} onChange={(e)=>setAddress(e.target.value)}/>
            </Form.Group>
            <Button className="submit-btn" onClick={addSchool}>Submit</Button>
          </Form>
        </Modal.Body>
      </Modal>
    </Layout>
  );
};

export default Document;
