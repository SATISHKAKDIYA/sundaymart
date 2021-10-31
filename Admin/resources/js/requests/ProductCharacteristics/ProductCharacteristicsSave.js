import axios from "axios";

const productCharacteristicsSave = async (product_id, keys, values, active, id) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/products-characterics/save";
    const body = {
        id_product: product_id,
        key: keys,
        value: values,
        active: active,
        id: id
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

export default productCharacteristicsSave;
