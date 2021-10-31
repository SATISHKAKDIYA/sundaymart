import axios from "axios";

const extrasGet = async (id) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/extra/get";
    const body = {
        id: id,
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

export default extrasGet;
