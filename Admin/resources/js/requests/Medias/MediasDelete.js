import axios from "axios";

const mediasDelete = async (urlString) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/media/delete";
    const body = {
        url: urlString,
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

export default mediasDelete;
