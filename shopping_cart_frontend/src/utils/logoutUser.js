import api from '@/services/api';

export default function (logoutPath) {
  return api.delete(logoutPath)
    .then(() => {
      localStorage.removeItem('access_token');
      localStorage.removeItem('refresh_token');
    })
}