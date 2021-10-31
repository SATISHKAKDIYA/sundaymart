import axios from "axios";

const addressActive = async (client_id) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/address/active";
    const body = {
        client_id: client_id,
    };

    const headers = {
        "Authorization": "Bearer " + token
    }

    const response = await axios({
        method: 'post',
        url: url,
        data: body,
        headers: headers
    });

    return response;
}

export default addressActive;
