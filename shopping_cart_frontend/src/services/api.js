import axios from 'axios';
import { HOST } from '@/utils/constant';

let api = axios.create({
  baseURL: `${HOST}/api/v1/`,
  headers: {
    'Content-Type': 'application/json',
  }
})

export default api