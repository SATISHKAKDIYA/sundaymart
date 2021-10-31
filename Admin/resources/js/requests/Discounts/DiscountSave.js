import axios from "axios";

const discountSave = async (id_shop, type, value, is_countdown, start_date, end_date, products, active, id) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/discount/save";
    const body = {
        id_shop: id_shop,
        discount_type: type,
        discount_amount: value,
        id: id,
        is_count_down: is_countdown,
        start_time: start_date,
        end_time: end_date,
        active: active,
        product_ids: products,
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

export default discountSave;
