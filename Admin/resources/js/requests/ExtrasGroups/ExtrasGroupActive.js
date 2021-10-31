import axios from "axios";

const extraGroupActive = async (product_id) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/extra-group/active";
    const body = {
        product_id: product_id,
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

export default extraGroupActive;
