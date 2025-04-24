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

export function handleResponseInterceptor(api) {
  api.interceptors.response.use(res => res, async error => {
    if (error?.response?.status === 401 && error?.config?.url !== PATHS.refresh) {
      let refreshToken = localStorage.getItem('refresh_token');
      if(!refreshToken) {
        handleExpiredRefreshToken()
        return Promise.reject(error)
      }

      try {
        let response = await api.post(PATHS.refresh, {
          refresh_token: refreshToken
        })
        if (response.status === 200) {
          const { access_token } = response.data;
          localStorage.setItem('access_token', access_token);
          
          return api(error.config);
        } else {
          return Promise.reject(error);
        }
      } catch(err) {
        handleExpiredRefreshToken()
        return Promise.reject(error);
      }
    }
    return Promise.reject(error)
  })
}

