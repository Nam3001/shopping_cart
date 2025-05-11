import api from "@/services/api";
import PATHS from "@/services/paths";
import router from '@/router'

export async function checkLoggedIn() {
  try {
    let res = await api.get(PATHS.me)
    if (res.status === 200) {
      return true
    }
    return false
  } catch (err) {
    return false
  }
}

export function handleExpiredRefreshToken() {
  localStorage.removeItem('access_token')
  localStorage.removeItem('refresh_token')

  alert('Login session was expired, please login again');
  router.push({ name: 'login' })
}