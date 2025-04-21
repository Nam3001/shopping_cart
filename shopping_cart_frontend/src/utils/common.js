import api from "@/services/api";
import PATHS from "@/services/paths";

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
  console.log('Login session was expired, please login again');
  window.location.assign('admin/login')
}