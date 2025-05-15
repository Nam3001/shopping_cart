import { handleExpiredRefreshToken } from "@/utils/common";
import PATHS from "./paths";

export function handleRequestInterceptor(api) {
  api.interceptors.request.use(config => {
    const token = localStorage.getItem('access_token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config
  });
}

// export function handleResponseInterceptor(api) {
//   api.interceptors.response.use(res => res, async error => {
//     if (error?.response?.status === 401 && error?.config?.url !== PATHS.refresh) {
//       let refreshToken = localStorage.getItem('refresh_token');
//       if(!refreshToken) {
//         return Promise.reject(error)
//       }

//       try {
//         let response = await api.post(PATHS.refresh, {
//           refresh_token: refreshToken
//         })
//         if (response.status === 200) {
//           const { access_token } = response.data;
//           localStorage.setItem('access_token', access_token);
          
//           return api(error.config);
//         } else {
//           return Promise.reject(error);
//         }
//       } catch(err) {
//         handleExpiredRefreshToken()
//         return Promise.reject(error);
//       }
//     }
//     return Promise.reject(error)
//   })
// }

// second way
export function handleResponseInterceptor(api) {
  let isRefreshing = false
  let failedQueue = []

  function attachNewAccessToken(config, accessToken) {
    localStorage.setItem('access_token', accessToken)

    // api.defaults.headers.common["Authorization"] = `Bearer ${newAccessToken}`
    config.headers['Authorization'] = `Bearer ${accessToken}`
  }

  function handleFailedQueue(error = null, token = null) {
    failedQueue.forEach(prom => {
      if(error) {
        prom.reject(error)
      } else {
        prom.resolve(token)
      }
    })

    failedQueue = []
  }

  api.interceptors.response.use(res => res, async error => {
    let previousRequest = error.config

    if(error?.response?.status === 401 && !previousRequest._retry) {
      previousRequest._retry = true

      if(isRefreshing) {
        if(error?.config?.url !== PATHS.refresh) {
          // return a promise, and add that promise to queue to wait to handle(resolve/reject) when finishing getting new access token by using refresh token
          return new Promise((resolve, reject) => {
            failedQueue.push(resolve, reject)
          })
          .then((token) => {
            attachNewAccessToken(previousRequest, token)
            return api(previousRequest)
          })
          .catch((err) => Promise.reject(err))
        } else {
          return Promise.reject(error)
        }
      }

      let refresh_token = localStorage.getItem('refresh_token')
      if(!refresh_token) {
        handleFailedQueue(error, null)
        return Promise.reject(error)
      }

      try {
        isRefreshing = true
        let response = await api.post(PATHS.refresh, { refresh_token })
        let { access_token } = response.data
        
        attachNewAccessToken(previousRequest, access_token)
        handleFailedQueue(null, access_token)

        return api(previousRequest)
      } catch(err) {
        handleExpiredRefreshToken() // handle when cannot get new access token by using refresh token (expired/invalid token...)
        handleFailedQueue(error, null)
        return Promise.reject(error)
      } finally {
        isRefreshing = false
      }
    } else {
      return Promise.reject(error)
    }
  })
}