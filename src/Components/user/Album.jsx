import React from "react";
import { Col, Row, Form } from "react-bootstrap";

const Album = ({ albums, con }) => {
  const pf = process.env.REACT_APP_PUBLIC_URL;
  // const pf = "http://192.168.40.160:3000";
  console.log(albums, "=================");

  return (
    <div className="p-5">
      <div className="user_details p-4">
        <Row>
          <Col lg={12}>
            <div className="user-data user-data-frame2">
              <div className="user-data-header ">
                <Form.Label className="mb-0">{con+"s"}</Form.Label>
              </div>
              <div className="user-data-table mt-2 bg-white border-0">
                <div className="d-flex justify-content-center flex-wrap profile-gap width-div">
                  {/* video */}
                  {con === "video" ? (
                    albums?.length !== 0 ? (
                      albums?.map((v, i) => {
                        return (
                          <>
                            <div className="img-div rounded-0" key={i}>
                              <video
                                width="320"
                                height="240"
                                controls
                                src={
                                  v?.path
                                    ? `${pf}/${v?.path}`
                                    : "../images/user.png"
                                }
                                alt=""
                                className="img-fluid"
                              ></video>
                            </div>
                          </>
                        );
                      })
                    ) : (
                      <div className="img-div w-100 text-center">
                        <h1>No added videos</h1>
                      </div>
                    )
                  ) : albums?.length !== 0 ? (
                    albums?.map((v, i) => {
                      return (
                        <div className="img-div" key={i}>
                          <img
                            src={
                              v?.path
                                ? `${pf}/${v?.path}`
                                : "../images/user.png"
                            }
                            alt=""
                            className="img-fluid"
                          />
                        </div>
                      );
                    })
                  ) : (
                    <div className="img-div w-100 text-center">
                      <h1>No added images </h1>
                    </div>
                  )}

                  {/* <div className="img-div">
                                        <img src="../images/frame2.svg" alt="" className='img-fluid' />
                                    </div>

                                    <div className="img-div">
                                        <img src="../images/frame2.svg" alt="" className='img-fluid' />
                                    </div>

                                    <div className="img-div">
                                        <img src="../images/frame2.svg" alt="" className='img-fluid' />
                                    </div>

                                    <div className="img-div">
                                        <img src="../images/frame2.svg" alt="" className='img-fluid' />
                                    </div>

                                    <div className="img-div">
                                        <img src="../images/frame2.svg" alt="" className='img-fluid' />
                                    </div> */}
                </div>
              </div>
            </div>
          </Col>
        </Row>
      </div>
    </div>
  );
};

export default Album;
