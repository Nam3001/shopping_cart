import axios from 'axios';
import { HOST } from '@/utils/constant';
import { handleRequestInterceptor, handleResponseInterceptor } from './interceptor';

let api = axios.create({
  baseURL: `${HOST}/api/v1/`,
  headers: {
    'Content-Type': 'application/json',
  }
})

handleRequestInterceptor(api);
handleResponseInterceptor(api);

export default api