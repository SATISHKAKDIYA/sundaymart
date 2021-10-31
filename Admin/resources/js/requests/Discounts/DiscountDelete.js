import axios from "axios";

const discountDelete = async (id) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/discount/delete";
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

export default discountDelete;
