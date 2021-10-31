import axios from "axios";

const productActive = async (shop_id) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/product/active";
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

export default productActive;
