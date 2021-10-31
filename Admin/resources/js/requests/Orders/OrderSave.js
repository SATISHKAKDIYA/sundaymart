import axios from "axios";

const orderSave = async (params, state, id) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/order/save";

    const body = {
        id: id,
        tax: state.tax,
        delivery_fee: state.delivery_fee,
        total_sum: state.total,
        total_discount: state.total_discount,
        delivery_time_id: params.delivery_time,
        delivery_date: state.delivery_date,
        comment: params.order_comment,
        type: params.delivery_type,
        id_user: params.client,
        id_delivery_address: params.address,
        id_shop: params.shop,
        order_status: params.order_status,
        payment_status: params.payment_status,
        payment_method: params.payment_method,
        product_details: state.product_details,
        delivery_boy_comment: params.delivery_boy_comment,
        delivery_boy: params.delivery_boy,
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

export default orderSave;
