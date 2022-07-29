import axios from "axios"
const COMMON_ERROR = "Error, Please try again.!"
const errorResponse = (error) => {
    if (error.response) {
          const { status, data } = error.response
          if (status === 403) {
                setTimeout(() => {
                      window.location.href = "/"
                      localStorage.clear()
                }, 5000);
          }
          return data
    } else {
          return { status: 0, message: COMMON_ERROR }
    }
}

//LOGIN

export const login = async(requestData) =>{
    try {
        const { email, password } = requestData
        const login = await axios.post("/sign-in", { email, password })
        const { data } = login
        console.log("login--responce-----",login)
        return data
  } catch (error) {
        return errorResponse(error)
  }
}

// USER

export const getAllUser = async (perPage , page = 1 , searchData) => {
      try {
           console.log("get all user function")
            const AllUser = await axios.get(`/all-user?perPage=${perPage}&page=${page}&search=${searchData}`)
            const { data } = AllUser
            return data
      } catch (error) {
            return errorResponse(error)
      }
}

export const singleUserDetail = async (id) => {
      try {
           console.log("check")
            const userDetail = await axios.get(`/get-user-by-id?id=${id}`)
            console.log("check",userDetail)
            const { data } = userDetail
            return data
      } catch (error) {
            return errorResponse(error)
      }
}

// All SCHOOL

export const getAllSchool = async (perPage , page=1 , searchData) => {
      try {
           
      //       const AllSchool= await axios.get(`/all-user/?perPage=${perPage}&page=${page}&search=${searchData}`)
      const AllSchool= await axios.get(`/get-all-school?perPage=${perPage}&page=${page}&search=${searchData}`)
      console.log("AllSchool-------",AllSchool)
            const { data } = AllSchool
            return data
      } catch (error) {
            return errorResponse(error)
      }
} 


// All SCHOOL for user request

export const getAllSchoolsRequest = async (perPage , page=1 , searchData) => {
      try {
           
            const AllSchool= await axios.get(`/get-school`)
            const { data } = AllSchool
            return data
      } catch (error) {
            return errorResponse(error)
      }
}

//  SCHOOL

export const getSchool = async (perPage , page=1 , searchData,id) => {
      try {
           
            const AllSchool= await axios.get(`/get-all-superlative?perPage=${perPage}&page=${page}&id=${id}&search=${searchData}`)
            const { data } = AllSchool
            return data
      } catch (error) {
            return errorResponse(error)
      }
}

//ABOUT

export const updateAbout = async (id) => {
      try {
           
            const aboutDetail = await axios.post(`/about-us`)
            const { data } = aboutDetail;
            return data
      } catch (error) {
            return errorResponse(error)
      }
}

//album

export const getAlbum = async (type,id) => {
      try {
           
            const album = await axios.post(`/get-all-document?id=${id}`,{type})
            const { data } = album;
            return data
      } catch (error) {
            return errorResponse(error)
      }
}

export const getChatuser = async (id) => {
      try {
           
            const user = await axios.get(`/get-user-chat?id=${id}`)
            const { data } = user;
            return data
      } catch (error) {
            return errorResponse(error)
      }
}
export const getChatById = async (id) => {
      try {
           
            const user = await axios.post("/user-chat",{id})
            const { data } = user;
            return data
      } catch (error) {
            return errorResponse(error)
      }
}
export const schoolNominees = async (id) => {
      try {
           
            const user = await axios.get(`/get-nominees?id=${id}`,)
            const { data } = user;
            return data
      } catch (error) {
            return errorResponse(error)
      }
}
export const getAllLiveUser = async (id) => {
      try {
           
            const user = await axios.get("/dashboard")
            const { data } = user;
            return data
      } catch (error) {
            return errorResponse(error)
      }
}
