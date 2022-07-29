import React, { useCallback, useEffect, useState } from "react";
import { Button, Col, NavLink, Row, Table } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import Layout from '../../../Layout';
import { useParams } from "react-router-dom";
import moment from "moment";
import localization from "moment/locale/en-in";
import Pagination_new from "../../Pagination_new";
import { schoolNominees } from "../../../controller/api";
import LoadingSpinner from "../../LoadingSpinner/LoaderSpinner";

const Nominees = () => {
    const [searchData, setSearchData] = useState("");
  const [schools, setSchools] = useState([]);
  const [nominees, setNominees] = useState([]);
  const [snominees, setSNominees] = useState([]);
  const [Current_page, setCurrent_page] = useState(1);
  const [loading, setLoading] = useState(true);
  const [togel, setTogel] = useState(true);
  const [Pagination,setPagination] =useState(1);
  const { id } = useParams();
  const per_page = 3;
  const pf = process.env.REACT_APP_PUBLIC_URL;
  moment.updateLocale("en-in", localization);
 


    //METHOD
const searching=(e)=>{
    
   if(searchData.length){
   
    setCurrent_page(1)
    console.log("school----",schools)
    setSNominees(schools.filter((user)=> new RegExp(searchData,"i").test(`${user.users?.first_name + user?.users?.last_name}` )))
    setNominees(snominees?.slice(Current_page - 1, per_page));
    console.log(snominees,"------------f-n")
    setPagination(snominees? Math.ceil(schools.filter((user)=> new RegExp(searchData,"i").test(`${user.users?.first_name + user?.users?.last_name}` ))?.length / per_page): 1)
    
    console.log("ser--",searchData,"current--",Current_page,"pagina---",Pagination,"nomis---",nominees,"nominees",snominees)
    
}else{
    setCurrent_page(1)
    setNominees( schools?.slice(Current_page - 1, per_page))
    setPagination(schools? Math.ceil(schools?.length / per_page): 1)
    setSNominees(schools)
    }
}

    const AllNomi = (pages) => {
        console.log("pages---", pages);
    
        if (pages === 1) {
            setNominees(schools?.slice(pages - 1, per_page));
        } else {
            setNominees( schools?.slice(  pages * per_page - per_page,  pages * per_page - per_page + per_page) );
        }
        setCurrent_page(pages);
      };
    

    const rever =() => {
        console.log("reve-----------")
        setNominees( nominees.reverse())
      };
    
    
      
      useEffect(() => {
        const getSingleUser = async () => {
          try {
            const nome = await schoolNominees(id);
            const { status, message, data } = nome;
            console.log(data,"nomi----------")
            if (status === 1) {
                setSchools(data);
                setPagination(data? Math.ceil(data?.length / per_page): 1)
                setSNominees(data);
                setNominees(() => data?.slice(Current_page - 1, per_page));
                setLoading(false);
            }
          } catch (error) {
            console.log(error);
            setLoading(false);
          }
        };
        getSingleUser();
      }, []);
    useEffect(() => {
        rever()
      }, [togel]);
    useEffect(() => {
        searching()
      }, [searchData,nominees]);
    return (
        <Layout>
            <div className="user-main py-4 px-5">
                <Row>
                    <Col lg={12}>
                        <div className="user-data">
                            <div className="user-data-header d-flex align-items-center justify-content-between">
                                <h1>Nominees</h1>
                                <input
                                    type="text"
                                    value={searchData}
                                    onChange={(e)=>setSearchData(e.target.value)} />
                            </div>
                            <div className="user-data-table mt-4">
                                <Table responsive className="mb-0 px-4 pb-2">
                                    <thead>
                                        <tr>
                                            <th className="p-0">
                                                <span className="d-block py-3 px-5">Name</span>
                                            </th>
                                            <th className="p-0">
                                                <span className="d-block py-3 px-5">Superlatives</span>
                                            </th>

                                            <th className="p-0">
                                                <span className="d-block py-3 px-5">Email</span>
                                            </th>
                                            <th className="p-0">
                                                <span className="d-flex py-3 px-5">
                                                    Create At
                                                    <Button className="bg-transparent border-0 shadow-none p-0"  onClick={() => setTogel((toge) => !toge)}>
                            <img src="../images/sorting-new.png" alt="" />
                          </Button>
                                                </span>
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    {!loading && nominees.length !== 0 && nominees?.map((user,i) => {
                                        return(
                                            <tr key={i}>
                                            <td className="bg-orange">
                                                <div className="delete-group ">
                                                    <Link
                                                        to=''
                                                        className="d-flex align-items-center gap-3 p-0 text-decoration-none"
                                                    >
                                                        <img
                                                            className="round_img"
                                                            src={user.users?.user_profile_image ? `${pf}/${user.users?.user_profile_image}` : "../images/user.png" } 
                                                            alt="user profile"
                                                        />
                                                        <span className="d-block">{`${user.users?.first_name + " " + user?.users?.last_name}`}</span>
                                                    </Link>
                                                </div>
                                            </td>
                                            <td className="bg-orange">
                                                <Link to='' className="d-flex align-items-center gap-3 px-5 text-decoration-none">
                                                    <span className='trophy'>
                                                        <img src="../images/trophy.svg"
                                                            alt=""
                                                        />
                                                    </span>
                                                    <span className="d-block">{user.superlatives?.category_name}</span>
                                                </Link>
                                            </td>
                                            <td className="bg-orange">
                                                <span className="d-block cp px-5">{user.users?.email}</span>
                                            </td>

                                            <td className="bg-orange">
                                                <span className="d-block cp px-5">
                                                {moment(user?.createdAt).format('L')}
                                                </span>
                                            </td>

                                        </tr>
                                        )
                                    })}
                                       
                                    </tbody>
                                </Table>
                            </div>
                            {loading ? <h1 className="lod"><LoadingSpinner /></h1> : nominees.length === 0 ? <h1 className="lod">no data available of Nominees</h1> : null}
                <div className="d-flex justify-content-end mt-4">
                  <Pagination_new
                          AllUser={AllNomi}
                          pagination={Pagination}
                          current_page={Current_page}
                        />
                </div>
                        </div>
                    </Col>
                </Row>
            </div>
        </Layout>
    )
}

export default Nominees