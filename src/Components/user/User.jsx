import React, { useState, useEffect, useRef } from "react";
import { Button, Col, Modal, NavLink, Pagination, Row, Table } from "react-bootstrap";
import Layout from "../../Layout";
import { GrFormClose } from "react-icons/gr";
import "./user.css";
import { Link } from "react-router-dom";
import { getAllUser } from "../../controller/api";
import { toast } from "react-toastify";
import Pagination_new from "../Pagination_new";
import moment from "moment";
import localization from 'moment/locale/en-in';
import LoadingSpinner from "../LoadingSpinner/LoaderSpinner";


const User = (props) => {
  // const [update, setUpdate] = useState(true);
  const [show, setShow] = useState(false);
  const [allUser, setAllUser] = useState([]);
  const [allUserRev, setAllUserRev] = useState([]);
  const [togel, setTogel] = useState(true);
  const [searchData, setSearchData] = useState("");
  const [paginationVal, setPaginationVal] = useState(1);
  const [current_page, setCurrent_page] = useState(1);
  const [loading, setLoading] = useState(true);
  const UserRev = allUser ? allUser : null
  const perPage = 10

  const pf = process.env.REACT_APP_PUBLIC_URL;
  // const pf = "http://192.168.40.160:3000"
  moment.updateLocale('en-in', localization);


  // METHODS


  const handleClose = () => setShow(false);
  const handleShow = () => setShow(true);

  const rever = () => {
    console.log(" time time out-------")
    setAllUser(allUser.reverse())

  }


  const AllUser = async (pages = 1) => {
    setLoading(true);
    if (togel == false) {
      setTogel(true)
    }
    try {
      const User = await getAllUser(perPage, pages, searchData);
      if (User) {
        const { status, message, data, count, paginationValue, page } = User;
        if (status === 1) {
          setAllUser(data);
          setPaginationVal(paginationValue);
          setCurrent_page(page)
          setLoading(false);
        } else {
          toast.error(message);
          setLoading(false);
        }
      }
    } catch (error) {
      console.log(error)
    }
  };


  useEffect(() => {
    AllUser();
  }, [searchData]);


  useEffect(() => {
    rever()
  }, [togel, allUser]);


  return (
    <Layout>
      {true ? (
        <div className="user-main py-4 px-5">
          <Row>
            <Col lg={12}>
              <div className="user-data">
                <div className="user-data-header d-flex align-items-center justify-content-between">
                  <h1>User</h1>
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
                          <span className="d-block py-3 px-5">Gender</span>
                        </th>
                        <th className="p-0">
                          <span className="d-block py-3 px-5">Birthdate</span>
                        </th>
                        <th className="p-0">
                          <span className="d-block py-3 px-5">Email</span>
                        </th>
                        <th className="p-0" colSpan={2}>
                          <span className="d-flex py-3 px-5">
                            Create At
                            <Button className="bg-transparent border-0 shadow-none p-0" onClick={() => setTogel((toge) => !toge)} >
                              <img src="./images/sorting-new.png" alt="" className="mt-0" />
                            </Button>
                          </span>
                        </th>
                      </tr>
                    </thead>
                    <tbody>
                      {!loading && allUser.length !== 0 && allUser?.map((user) => {
                        const { _id, user_profile_image, first_name, last_name, gender, createdAt, email, dob } = user;

                        return (
                          <tr key={_id}>
                            <td className="bg-orange">
                              <div className="delete-group ">
                                <Link
                                  to={`/userdetails/${_id}`}
                                  className="d-flex align-items-center gap-3 p-0 text-decoration-none"
                                >
                                  <img
                                    className="round_img"
                                    src={
                                      user_profile_image
                                        ? `${pf}/${user_profile_image}`
                                        : "./images/user.png"
                                    }
                                    alt="user profile"
                                  />
                                  <span className="d-block">{`${first_name + " " + last_name}`}</span>
                                </Link>
                              </div>
                            </td>
                            <td className="bg-orange">
                              <span className="d-block cp px-5">
                                {gender}
                              </span>
                            </td>
                            <td className="bg-orange">
                              <span className="d-block cp px-5">{moment(dob).format('L')}</span>
                            </td>
                            <td className="bg-orange">
                              <span className="d-block cp px-5">
                                {email}
                              </span>
                            </td>
                            <td className="bg-orange">
                              <span className="d-block cp px-5">
                                {moment(createdAt).format('L')}
                              </span>
                            </td>
                            <td className="bg-orange">
                              <div className="delete-group d-flex align-items-center justify-content-center gap-3 py-2">
                                <Link to={`/chat/${_id}`}>
                                  <Button>Chat</Button>
                                </Link>
                              </div>
                            </td>
                          </tr>
                        );
                      })}
                    </tbody>
                  </Table>
                </div>
                {loading ? <h1 className="lod"><LoadingSpinner /></h1> : allUser.length === 0 ? <h1 className="lod">no data available of users</h1> : null}
                <div className="d-flex justify-content-end mt-4">
                  <Pagination_new
                    AllUser={AllUser}
                    pagination={paginationVal}
                    current_page={current_page}
                  />
                </div>
              </div>
            </Col>
          </Row>
        </div>
      ) : (
        <div className="user-main py-4 px-5">
          <Row>
            <Col xl={11} lg={12}>
              <div className="user-info">
                <h5>User Information</h5>
                <Row className="mt-4">
                  <Col lg={6} md={6} sm={12} className="mt-3">
                    <div className="input-field">
                      <label>First Name</label>
                      <input type="text" />
                    </div>
                  </Col>
                  <Col lg={6} md={6} sm={12} className="mt-3">
                    <div className="input-field">
                      <label>Last Name</label>
                      <input type="text" />
                    </div>
                  </Col>
                </Row>
                <div className="input-field mt-3">
                  <label>Email Address</label>
                  <input type="text" />
                </div>
                <div className="patient-name mt-5">
                  <label>Patient Name</label>
                  <div className="user-data-table">
                    <Table responsive className="mb-0">
                      <thead>
                        <tr>
                          <th className="p-0">
                            <span className="d-block py-3 px-5">Name</span>
                          </th>
                          <th className="p-0">
                            <span className="d-block py-3 px-5">Email</span>
                          </th>
                          <th className="p-0">
                            <span className="d-block py-3 px-5">Bcc</span>
                          </th>
                          <th className="p-0">
                            <span className="d-block py-3 px-5">Disease</span>
                          </th>
                          <th className="p-0">
                            <span className="d-block py-3 px-5">Code</span>
                          </th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td>
                            <span className="d-block py-3 px-5">
                              John Revon
                            </span>
                          </td>
                          <td>
                            <NavLink>John152@gmail.com</NavLink>
                          </td>
                          <td>
                            <span className="d-block py-3 px-5">XYZ</span>
                          </td>
                          <td>
                            <span className="d-block py-3 px-5">XYZ</span>
                          </td>
                          <td>
                            <span className="d-block py-3 px-5">XYZ</span>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <span className="d-block py-3 px-5">
                              John Revon
                            </span>
                          </td>
                          <td>
                            <NavLink>John152@gmail.com</NavLink>
                          </td>
                          <td>
                            <span className="d-block py-3 px-5">XYZ</span>
                          </td>
                          <td>
                            <span className="d-block py-3 px-5">XYZ</span>
                          </td>
                          <td>
                            <span className="d-block py-3 px-5">XYZ</span>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <span className="d-block py-3 px-5">
                              John Revon
                            </span>
                          </td>
                          <td>
                            <NavLink>John152@gmail.com</NavLink>
                          </td>
                          <td>
                            <span className="d-block py-3 px-5">XYZ</span>
                          </td>
                          <td>
                            <span className="d-block py-3 px-5">XYZ</span>
                          </td>
                          <td>
                            <span className="d-block py-3 px-5">XYZ</span>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <span className="d-block py-3 px-5">
                              John Revon
                            </span>
                          </td>
                          <td>
                            <NavLink>John152@gmail.com</NavLink>
                          </td>
                          <td>
                            <span className="d-block py-3 px-5">XYZ</span>
                          </td>
                          <td>
                            <span className="d-block py-3 px-5">XYZ</span>
                          </td>
                          <td>
                            <span className="d-block py-3 px-5">XYZ</span>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <span className="d-block py-3 px-5">
                              John Revon
                            </span>
                          </td>
                          <td>
                            <NavLink>John152@gmail.com</NavLink>
                          </td>
                          <td>
                            <span className="d-block py-3 px-5">XYZ</span>
                          </td>
                          <td>
                            <span className="d-block py-3 px-5">XYZ</span>
                          </td>
                          <td>
                            <span className="d-block py-3 px-5">XYZ</span>
                          </td>
                        </tr>
                      </tbody>
                    </Table>
                  </div>
                  <div className="d-flex justify-content-end mt-4">
                    <Pagination>
                      <Pagination.Prev />
                      <Pagination.Item>{1}</Pagination.Item>
                      <Pagination.Item>{2}</Pagination.Item>
                      <Pagination.Item>{3}</Pagination.Item>
                      <Pagination.Item active>{4}</Pagination.Item>
                      <Pagination.Next />
                    </Pagination>
                  </div>
                </div>
              </div>
            </Col>
          </Row>
        </div>
      )}

      <Modal show={show} onHide={handleClose} centered>
        <Modal.Body>
          <div className="modal-title text-center position-relative">
            <h2>Create User</h2>
            <Button className="modal-close-btn" onClick={() => handleClose()}>
              <GrFormClose />
            </Button>
          </div>

          <div className="modal-form my-4">
            <div className="input-field">
              <label>Name</label>
              <input type="text" />
            </div>
            <div className="input-field mt-4">
              <label>Email</label>
              <input type="text" />
            </div>
            <div className="input-field mt-4">
              <label>Password</label>
              <input type="text" />
            </div>
            <div className="input-field mt-4">
              <label>Confirm Password</label>
              <input type="text" />
            </div>
          </div>

          <div className="modal-btn-group d-flex align-items-center justify-content-end gap-3">
            <Button className="cancel" onClick={() => handleClose()}>
              Cancel
            </Button>
            <Button className="ok">OK</Button>
          </div>
        </Modal.Body>
      </Modal>
    </Layout>
  );
};

export default User;
