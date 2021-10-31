import axios from "axios";

const couponSave = async (name, description, shop_id, discount_type, discount, usage_time, valid, products, active, id) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/coupon/save";
    const body = {
        name: name,
        description: description,
        active: active,
        id: id,
        shop_id: shop_id,
        discount_type: discount_type,
        discount: discount,
        usage_time: usage_time,
        valid: valid,
        products: products,
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

export default couponSave;
