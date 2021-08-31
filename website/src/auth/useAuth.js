import { useState, useEffect } from "react";
import { addAuthListener } from "./addAuthListener";
import { getCurrentUser } from "./getCurrentUser";
export const useAuth = () => {
  const [authInfo, setAuthInfo] = useState(() => {
    const user = getCurrentUser();
    const isLoading = !user;
    return {
      isLoading,
      user,
    };
  });
  useEffect(() => {
    return addAuthListener((user) => {
      setAuthInfo({ isLoading: false, user });
    });
  }, []);
  return authInfo;
};
