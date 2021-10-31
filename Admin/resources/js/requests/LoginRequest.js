import axios from "axios";

const login = async (email, password) => {
    const url = "/api/auth/login";
    const body = {
        email: email,
        password: password
    };

    return await axios.post(url, body);
}

export default login;
