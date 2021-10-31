import axios from "axios";

const shopTotalGet = async () => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/dashboard/shops/total";
    const body = {};

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

export default shopTotalGet;
