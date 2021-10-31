import axios from "axios";

const addressSave = async (params) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/address/save";
    const body = params;

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

export default addressSave;
