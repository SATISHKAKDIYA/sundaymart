import axios from "axios";

const categoryActive = async (shop_id) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/category/active";
    const body = {
        shop_id: shop_id,
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

export default categoryActive;
