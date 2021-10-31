import axios from "axios";

const extrasGroupDelete = async (id) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/extra-group/delete";
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

export default extrasGroupDelete;
